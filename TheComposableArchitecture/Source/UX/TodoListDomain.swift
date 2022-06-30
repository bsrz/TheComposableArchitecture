import ComposableArchitecture

enum TodoListDomain {
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
    }

    enum Action: Equatable {
        case add
        case todo(id: Todo.ID, action: TodoDomain.Action)
        case todoDelayCompleted
    }

    struct Environment {
        var mainScheduler: AnySchedulerOf<DispatchQueue>
        var makeUUID: () -> UUID
    }

    static let reducer: Reducer<State, Action, Environment> = .combine(
        TodoDomain.reducer
            .forEach(
                state: \TodoListDomain.State.todos,
                action: /TodoListDomain.Action.todo(id:action:),
                environment: { _ in .init() }
            ),
        .init { state, action, env in
            switch action {
            case .add:
                state.todos.insert(.init(id: env.makeUUID()), at: 0)
                return .none

            case .todo(id: _, action: .checkboxTapped):
                struct CancelDelayId: Hashable { }
                return Effect(value: Action.todoDelayCompleted)
                    .debounce(id: CancelDelayId(), for: 1, scheduler: env.mainScheduler)

            case .todo(id: let id, action: let action):
                return .none

            case .todoDelayCompleted:
                state.todos = IdentifiedArrayOf(uniqueElements: state
                    .todos
                    .enumerated()
                    .sorted { lhs, rhs in
                        (!lhs.element.isComplete && rhs.element.isComplete)
                        || lhs.offset < rhs.offset
                    }
                    .map(\.element)
                )

                return .none
            }
        }
    )
}
