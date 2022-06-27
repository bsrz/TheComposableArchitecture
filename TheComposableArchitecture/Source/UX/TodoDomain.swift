import ComposableArchitecture

enum TodoDomain {
    enum Action {
        case checkboxTapped
        case textFieldChange(String)
    }

    struct Environment {
    }

    static let reducer: Reducer<Todo, Action, Environment> = .init { todo, action, env in
        switch action {
        case .checkboxTapped:
            todo.isComplete.toggle()
            return .none

        case .textFieldChange(let text):
            todo.description = text
            return .none
        }
    }
}
