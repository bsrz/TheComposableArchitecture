import ComposableArchitecture

enum AppDomain {
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
    }

    enum Action {
        case add
        case todo(id: Todo.ID, action: TodoDomain.Action)
    }

    struct Environment {
        var makeUUID: () -> UUID
    }

    static let reducer: Reducer<State, Action, Environment> = .combine(
        TodoDomain.reducer
            .forEach(
                state: \AppDomain.State.todos,
                action: /AppDomain.Action.todo(id:action:),
                environment: { _ in .init() }
            ),
        .init { state, action, env in
            switch action {
            case .add:
                state.todos.insert(.init(id: env.makeUUID()), at: 0)
                return .none

            case .todo(id: let id, action: let action):
                return .none
            }
        }
    )
}
