@testable import TheComposableArchitecture
import ComposableArchitecture
import XCTest

class AppDomainTests: XCTestCase {

    private let scheduler = DispatchQueue.test

    func testDomain_whenIncompleteOnboarding() throws {
        let userDefaults = UserDefaults(suiteName: name)!
        let store = TestStore(
            initialState: .init(
                onboarding: nil,
                todoList: .init(),
                settings: .init()
            ),
            reducer: AppDomain.reducer,
            environment: .init(
                mainScheduler: scheduler.eraseToAnyScheduler(),
                makeUUID: UUID.init,
                userDefaults: userDefaults
            )
        )

        store.send(.onAppear) { state in
            state.onboarding = .init()
        }
    }
    func testDomain_whenCompletingOnboarding() throws {
        let userDefaults = UserDefaults(suiteName: name)!
        userDefaults.removePersistentDomain(forName: name)
        let store = TestStore(
            initialState: .init(
                onboarding: nil,
                todoList: .init(),
                settings: .init()
            ),
            reducer: AppDomain.reducer,
            environment: .init(
                mainScheduler: scheduler.eraseToAnyScheduler(),
                makeUUID: UUID.init,
                userDefaults: userDefaults
            )
        )

        // Welcome
        store.send(.onAppear) { state in
            state.onboarding = .init()
            state.onboarding?.step = .welcome
        }

        // First Name
        store.send(.onboarding(.next)) { state in
            state.onboarding?.step = .firstName
        }
        store.send(.onboarding(.firstName("foo"))) { state in
            state.onboarding?.user.firstName = "foo"
        }

        // Last Name
        store.send(.onboarding(.next)) { state in
            state.onboarding?.step = .lastName
        }
        store.send(.onboarding(.lastName("bar"))) { state in
            state.onboarding?.user.lastName = "bar"
        }

        // Email
        store.send(.onboarding(.next)) { state in
            state.onboarding?.step = .email
        }
        store.send(.onboarding(.email("qux"))) { state in
            state.onboarding?.user.email = "qux"
        }

        store.send(.onboarding(.next))
        store.receive(.onboarding(.delegate(.onboardingComplete))) { state in
            state.onboarding = nil
        }

        XCTAssertNotNil(userDefaults.data(forKey: "loggedInUser"))
    }
    func testDomain_whenLoggingOut() throws {
        let userDefaults = UserDefaults(suiteName: name)!
        userDefaults.removePersistentDomain(forName: name)

        let user = User(firstName: "foo", lastName: "bar", email: "qux")
        let encoded = try JSONEncoder().encode(user)

        userDefaults.set(encoded, forKey: "loggedInUser")
        XCTAssertNotNil(userDefaults.data(forKey: "loggedInUser"))

        let store = TestStore(
            initialState: .init(
                onboarding: .init(),
                todoList: .init(),
                settings: .init()
            ),
            reducer: AppDomain.reducer,
            environment: .init(
                mainScheduler: scheduler.eraseToAnyScheduler(),
                makeUUID: UUID.init,
                userDefaults: userDefaults
            )
        )

        store.send(.onAppear) { state in
            state.onboarding = nil
        }

        store.send(.settings(.delegate(.logout))) { state in
            state.onboarding = .init()
        }

        XCTAssertNil(userDefaults.data(forKey: "loggedInUser"))
    }
}
