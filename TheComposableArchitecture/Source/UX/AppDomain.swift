import ComposableArchitecture

enum AppDomain {
    struct State: Equatable {
        var todos: [Todo] = []
    }

    enum Action {
        case add
        case todo(index: Int, action: TodoDomain.Action)
    }

    struct Environment {

        init() { }

    }

    static let reducer: Reducer<State, Action, Environment> = .combine(
        TodoDomain.reducer
            .forEach(
                state: \AppDomain.State.todos,
                action: /AppDomain.Action.todo(index:action:),
                environment: { _ in .init() }
            ),
        .init { state, action, env in
            switch action {
            case .add:
                state.todos.insert(.init(), at: 0)
                return .none

            case .todo(index: let index, action: let action):
                return .none
            }
        }
    )
}
