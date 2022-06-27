import ComposableArchitecture

enum AppDomain {
    struct State: Equatable {
        var todos: [Todo] = []
    }

    enum Action {
        case todo(index: Int, action: TodoDomain.Action)
    }

    struct Environment {

        init() { }

    }

    static let reducer: Reducer<State, Action, Environment> = TodoDomain.reducer
        .forEach(
            state: \AppDomain.State.todos,
            action: /AppDomain.Action.todo(index:action:),
            environment: { _ in .init() }
        )
}
