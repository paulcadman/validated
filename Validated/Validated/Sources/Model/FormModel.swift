import RxSwift

struct FormModel {
    enum Reason {
        case emptyName
    }
    
    enum State: Equatable {
        case valid(name: String)
        case invalid(name: String, reason: Reason)
    }
    
    var state: Observable<State>
    var updateName: AnyObserver<String>
    
    private var _state = BehaviorSubject<State>(value: .invalid(name: "", reason: .emptyName))
    
    init() {
        updateName = _state.mapObserver { input in
            if input.isEmpty {
                return .invalid(name: input, reason: .emptyName)
            } else {
                return .valid(name: input)
            }
        }
        state = _state.asObservable().distinctUntilChanged()
    }
}
