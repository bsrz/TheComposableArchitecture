import ComposableArchitecture

enum OnboardingDomain {
    struct State: Equatable {

        var user: User = .init()
        var step: Step = Step.allCases.first!

        enum Step: Int, CaseIterable, Equatable {
            case welcome
            case firstName
            case lastName
            case email

            mutating func next() {
                self = Self(rawValue: self.rawValue + 1) ?? Self.allCases.last!
            }

            mutating func previous() {
                self = Self(rawValue: self.rawValue - 1) ?? Self.allCases.first!
            }

            static func < (lhs: Step, rhs: Step) -> Bool {
                lhs.rawValue < rhs.rawValue
            }
        }
    }

    enum Action {
        case next
        case firstName(String)
        case lastName(String)
        case email(String)
        case delegate(DelegateAction)

        enum DelegateAction {
            case onboardingComplete
        }
    }

    struct Environment {
        var userDefaults: UserDefaults
    }

    static let reducer: Reducer<State, Action, Environment> = .init { state, action, env in
        switch action {
        case .next:
            let previous = state.step
            state.step.next()

            if previous == state.step {
                return Effect(value: Action.delegate(.onboardingComplete))
            } else {
                return .none
            }

        case .firstName(let name):
            state.user.firstName = name
            return .none

        case .lastName(let name):
            state.user.lastName = name
            return .none

        case .email(let email):
            state.user.email = email
            return .none

        case .delegate(.onboardingComplete):
            guard let data = try? JSONEncoder().encode(state.user) else { return .none }
            env.userDefaults.set(data, forKey: "loggedInUser")
            return .none
        }
    }
}
