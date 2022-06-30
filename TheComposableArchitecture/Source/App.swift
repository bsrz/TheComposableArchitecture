import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            TodoListView(
                store: .init(
                    initialState: .init(
                        todos: [
                            .init(description: "Milk", isComplete: false),
                            .init(description: "Eggs", isComplete: false),
                            .init(description: "Hand Soap", isComplete: false)
                        ]
                    ),
                    reducer: TodoListDomain.reducer.debug(),
                    environment: .init(
                        mainScheduler: .main,
                        makeUUID: UUID.init
                    )
                )
            )
        }
    }
}
