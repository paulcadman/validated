import RxSwift

struct FormModel {
    enum State {
        case valid
        case invalid
    }
    
    var state: Observable<State> = Observable.just(.valid)
}
