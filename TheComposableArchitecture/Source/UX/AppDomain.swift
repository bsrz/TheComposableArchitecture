import ComposableArchitecture

enum AppDomain {
    struct State: Equatable {
        var onboarding: OnboardingDomain.State? = .init()
        var todoList: TodoListDomain.State
        var settings: SettingsDomain.State
    }

    enum Action: Equatable {
        case onAppear
        case onboarding(OnboardingDomain.Action)
        case todoList(TodoListDomain.Action)
        case settings(SettingsDomain.Action)
    }

    struct Environment {
        var mainScheduler: AnySchedulerOf<DispatchQueue>
        var makeUUID: () -> UUID
        var userDefaults: UserDefaults
    }

    static let reducer: Reducer<State, Action, Environment> = .combine(
        OnboardingDomain.reducer
            .optional()
            .pullback(
                state: \.onboarding,
                action: /AppDomain.Action.onboarding,
                environment: { global in
                    .init(
                        userDefaults: global.userDefaults
                    )
                }
            ),
        SettingsDomain.reducer
            .pullback(
                state: \.settings,
                action: /AppDomain.Action.settings,
                environment: { _ in .init() }
            ),
        TodoListDomain.reducer
            .pullback(
                state: \.todoList,
                action: /AppDomain.Action.todoList,
                environment: { global in
                    .init(
                        mainScheduler: global.mainScheduler,
                        makeUUID: global.makeUUID
                    )
                }
            ),
        .init { state, action, env in
            switch action {
            case .onAppear:
                guard
                    let data = env.userDefaults.data(forKey: "loggedInUser"),
                    let user =  try? JSONDecoder().decode(User.self, from: data)
                else {
                    state.onboarding = .init()
                    return .none
                }

                state.onboarding = nil

                return .none

            case .onboarding(.delegate(.onboardingComplete)):
                state.onboarding = nil
                return .none

            case .onboarding(let action):
                return .none

            case .todoList:
                return .none

            case .settings(.delegate(.logout)):
                env.userDefaults.removeObject(forKey: "loggedInUser")
                state.onboarding = .init()
                return .none
            }
        }
    )
}
