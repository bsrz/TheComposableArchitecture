@testable import TheComposableArchitecture
import ComposableArchitecture
import XCTest

class OnboardingTests: XCTestCase {
    func testReducer_whenSentNextAction() throws {
        // Arrange
        let userDefault = UserDefaults(suiteName: name)!
        let store = TestStore(
            initialState: OnboardingDomain.State(),
            reducer: OnboardingDomain.reducer,
            environment: .init(userDefaults: userDefault)
        )

        // Act & Assert
        XCTAssertEqual(store.state.step, .welcome)

        store.send(.next) { state in
            state.step = .firstName
        }

        store.send(.next) { state in
            state.step = .lastName
        }

        store.send(.next) { state in
            state.step = .email
        }

        store.send(.next)
        store.receive(.delegate(.onboardingComplete))
    }
}
