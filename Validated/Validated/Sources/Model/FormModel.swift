import RxSwift

struct FormModel {
    enum Reason {
        case emptyName
        case emptyAge
        case tooYoung
    }
    
    struct Validators {
        static func name(value: String) -> FieldState<String> {
            if value.isEmpty {
                return .invalid(value: value, reason: .emptyName)
            } else {
                return .valid(value: value)
            }
        }
        
        static func age(value: Int) -> FieldState<Int> {
            if value < 18 {
                return .invalid(value: .none, reason: .tooYoung)
            } else {
                return .valid(value: value)
            }
        }
    }
    
    enum State: Equatable {
        case valid(name: String, age: Int)
        case invalid(name: String?, age: Int?, reasons: Set<Reason>)
    }
    
    var state: Observable<State>
    var updateName: AnyObserver<String>
    var updateAge: AnyObserver<Int>
    
    init() {
        let name = FormField(initialState: .invalid(value: "", reason: .emptyName), validator: Validators.name(value:))
        let age = FormField(initialState: .invalid(value: .none, reason: .emptyAge), validator: Validators.age(value:))
        
        updateName = name.update
        updateAge = age.update
        
        state = Observable.combineLatest(name.state, age.state).map { (name, age) in
            switch (name, age) {
                
            case (.valid(let name), .valid(let age)):
                return .valid(name: name, age: age)
            case (.invalid(let name, let nameReason), .invalid(let age, let ageReason)):
                return .invalid(name: name, age: age, reasons: [nameReason, ageReason])
            case (.valid(let name), .invalid(let age, let reason)):
                return .invalid(name: name, age: age, reasons: [reason])
            case (.invalid(let name, let reason), .valid(let age)):
                return .invalid(name: name, age: age, reasons: [reason])
            }
        }
    }
}
