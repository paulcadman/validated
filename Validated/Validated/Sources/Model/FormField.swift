import RxSwift

enum FieldState<T: Equatable>: Equatable {
    case valid(value: T)
    case invalid(value: T?, reason: FormModel.Reason)
}

protocol FormFieldType {
    associatedtype T: Equatable
    
    var update: AnyObserver<T> { get }
    var state: Observable<FieldState<T>> { get }
}

struct FormField<T: Equatable>: FormFieldType {
    var state: Observable<FieldState<T>>
    var update: AnyObserver<T>
    
    init(initialState: FieldState<T>, validator: @escaping (T) -> FieldState<T>) {
        let _state = BehaviorSubject<FieldState<T>>(value: initialState)
        
        update = _state.mapObserver(validator)
        state = _state.asObservable().distinctUntilChanged()
    }
}
