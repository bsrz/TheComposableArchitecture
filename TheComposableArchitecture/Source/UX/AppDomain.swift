import ComposableArchitecture

enum AppDomain {
    struct State: Equatable {
        var todos: [Todo] = []
    }

    enum Action {
        case todoCheckboxTapped(index: Int)
        case todoTextFieldChanged(index: Int, text: String)
    }

    struct Environment {

        init() { }

    }

    static let reducer: Reducer<State, Action, Environment> = .init { state, action, env in
        switch action {
        case .todoCheckboxTapped(index: let index):
            state.todos[index].isComplete.toggle()
            return .none

        case .todoTextFieldChanged(index: let index, text: let text):
            state.todos[index].description = text
            return .none
        }
    }
}
