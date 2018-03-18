import RxSwift

struct FormModel {
    enum Reason {
        case emptyName
    }
    
    struct Fields {
        static let name = AnyFormField(initialState: .invalid(value: "", reason: .emptyName)) { input in
            if input.isEmpty {
                return .invalid(value: input, reason: .emptyName)
            } else {
                return .valid(value: input)
            }
        }        
    }
    
    enum State: Equatable {
        case valid(name: String)
        case invalid(name: String, reason: Reason)
    }
    
    var state: Observable<State>
    var updateName: AnyObserver<String>
    
    init() {
        updateName = Fields.name.update
        state = Fields.name.state.map { state in
            switch state {
            case .valid(let value):
                return .valid(name: value)
            case .invalid(let value, let reason):
                return .invalid(name: value, reason: reason)
            }
        }
    }
}
