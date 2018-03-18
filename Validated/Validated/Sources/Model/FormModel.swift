import RxSwift

enum FieldValid<T: Equatable>: Equatable {
    case valid(value: T)
    case invalid(value: T, reason: FormModel.Reason)
}

protocol FormField {
    associatedtype T: Equatable
    
    var update: AnyObserver<T> { get }
    var state: Observable<FieldValid<T>> { get }
}

struct Name: FormField {
    typealias T = String

    var state: Observable<FieldValid<T>>
    var update: AnyObserver<T>
    
    private static let initialState: FieldValid<T> = .invalid(value: "", reason: .emptyName)
    private var _state = BehaviorSubject<FieldValid<T>>(value: initialState)
    
    init() {
        update = _state.mapObserver { input in
            if input.isEmpty {
                return .invalid(value: input, reason: .emptyName)
            } else {
                return .valid(value: input)
            }
        }
        state = _state.asObservable().distinctUntilChanged()
    }
}

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
        
    init() {
        let name = Name()
        updateName = name.update
        state = name.state.map { state in
            switch state {
            case .valid(let value):
                return .valid(name: value)
            case .invalid(let value, let reason):
                return .invalid(name: value, reason: reason)
            }
            
        }
    }
}
