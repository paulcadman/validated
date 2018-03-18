import RxSwift

struct FormModel {
    enum State {
        case valid
        case invalid
    }
    
    var state: Observable<State>
    
    private var _state = BehaviorSubject<State>(value: .invalid)
    
    init() {
        state = _state.asObservable()
    }
    
    func update() {
        _state.onNext(.valid)
    }
}
