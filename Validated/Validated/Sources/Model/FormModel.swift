import RxSwift

struct FormModel {
    enum State {
        case valid
        case invalid
    }
    
    var state: Observable<State>
    var updateName: AnyObserver<String>
    
    private var _state = BehaviorSubject<State>(value: .invalid)
    
    init() {
        updateName = _state.mapObserver { input in
            if input.isEmpty {
                return .invalid
            } else {
                return .valid
            }
        }
        state = _state.asObservable().distinctUntilChanged()
    }
}
