import RxSwift

struct FormModel {
    enum Reason {
        case emptyName
    }
    
    enum State: Equatable {
        case valid
        case invalid(reason: Reason)
    }
    
    var state: Observable<State>
    var updateName: AnyObserver<String>
    
    private var _state = BehaviorSubject<State>(value: .invalid(reason: .emptyName))
    
    init() {
        updateName = _state.mapObserver { input in
            if input.isEmpty {
                return .invalid(reason: .emptyName)
            } else {
                return .valid
            }
        }
        state = _state.asObservable().distinctUntilChanged()
    }
}
