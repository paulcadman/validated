import RxSwift

struct FormModel {
    enum Reason {
        case emptyName
        case emptyAge
        case tooYoung
    }
    
    struct Fields {
        var name: FormField<String> {
            return FormField(initialState: .invalid(value: "", reason: .emptyName)) { input in
                if input.isEmpty {
                    return .invalid(value: input, reason: .emptyName)
                } else {
                    return .valid(value: input)
                }
            }
            
        }
        
        var age: FormField<Int> {
            return FormField(initialState: .invalid(value: .none, reason: .emptyAge)) { (input: Int) in
                if input < 18 {
                    return .invalid(value: .none, reason: .tooYoung)
                } else {
                    return .valid(value: input)
                }
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
        let fields = Fields()
        let name = fields.name
        let age = fields.age
        
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
