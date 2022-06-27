import ComposableArchitecture
import XCTest

@testable import TheComposableArchitecture

class AppDomainTests: XCTestCase {

    func testDomain_whenAddingTodo_updatesStateAsExpected() {
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let store = TestStore(
            initialState: .init(),
            reducer: AppDomain.reducer,
            environment: .init(
                makeUUID: { uuid }
            )
        )

        store.send(.add) { state in
            state.todos = [
                .init(
                    id: uuid,
                    description: "",
                    isComplete: false
                )
            ]
        }
    }
    func testDomain_whenCompletingTodo_updatesStateAsExpected() {
        let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let store = TestStore(
            initialState: .init(
                todos: [
                    .init(
                        id: uuid,
                        description: "Milk",
                        isComplete: false
                    )
                ]
            ),
            reducer: AppDomain.reducer,
            environment: .init(
                makeUUID: { fatalError() }
            )
        )

        store.send(.todo(id: uuid, action: .checkboxTapped)) { state in
            state.todos[id: uuid]?.isComplete = true
        }
    }
}
