import RxSwift
import Foundation
import XCTest

extension ObservableType where E: Equatable {
    func assert(startsWith elements: [E], with action: @escaping () -> ()) {
        switch verify(startsWith: elements, with: action) {
        case .some(let error):
            XCTFail("Assertion failed: \(error)")
        case .none:
            break
        }
    }
}

extension ObservableType where E: Equatable {
    func verify(startsWith elements: [E], with action: @escaping () -> ()) -> Verifier.Errors? {
        let actionSema = DispatchSemaphore(value: 0)
        let observableWithSignal = self.do(onSubscribed: { actionSema.signal() })
        
        DispatchQueue(label: "actions").async {
            switch actionSema.wait(timeout: DispatchTime.now() + 1) {
            case .success:
                action()
            case .timedOut:
                break
            }
        }
        return startSubscription(observableWithSignal, startsWith: elements)
    }
    
    fileprivate func startSubscription(_ observable: Observable<E>, startsWith elements: [E]) -> Verifier.Errors? {
        let verificationCompleteSema = DispatchSemaphore(value: 0)
        var pendingError: Verifier.Errors?
        
        var remainingElements = elements
        let nextElement = { () -> E? in
            guard !remainingElements.isEmpty else {
                return nil
            }
            return remainingElements.remove(at: 0)
        }
        
        let disposable = observable.subscribe { event in
            switch Verifier.verify(event, nextElement: nextElement) {
                
            case .fail(let error):
                pendingError = error
            case .ok:
                break
            }
            
            if remainingElements.isEmpty || pendingError != nil {
                verificationCompleteSema.signal()
            }
        }
        
        defer { disposable.dispose() }
        switch verificationCompleteSema.wait(timeout: DispatchTime.now() + 1) {
        case .success:
            return pendingError
        case .timedOut:
            return Verifier.Errors.TimedOut
        }
    }
}
