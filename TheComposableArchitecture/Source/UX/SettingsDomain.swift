import ComposableArchitecture

enum SettingsDomain {
    struct State: Equatable {
    }

    enum Action {
        case delegate(DelegateAction)

        enum DelegateAction {
            case logout
        }
    }

    struct Environment {
    }

    static let reducer: Reducer<State, Action, Environment> = .init { state, action, env in
        switch action {
        case .delegate(.logout):
            return .none
        }
    }
}
