import RxSwift

struct Verifier
{
    enum Errors: Error {
        case ElementsNotEqual(a: Any, b: Any)
        case TerminatedWithRemainingElements
        case NoMoreElements
        case TimedOut
    }
    
    enum Result {
        case ok
        case fail(error: Errors)
    }
    
    static func verify<E: Equatable>(_ event: Event<E>, nextElement: () -> E?) -> Result {
        switch event {
        case .next(let next):
            guard let element = nextElement() else {
                return .fail(error: .NoMoreElements)
            }
            
            if next != element {
                return .fail(error: .ElementsNotEqual(a: next, b: element))
            }
            
            return .ok
        default:
            return .fail(error: .TerminatedWithRemainingElements)
        }
    }
}
