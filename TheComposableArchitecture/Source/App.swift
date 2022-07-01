import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .init(
                        onboarding: nil,
                        todoList: .init(
                            todos: [
                                .init(description: "Milk", isComplete: false),
                                .init(description: "Eggs", isComplete: false),
                                .init(description: "Bacon", isComplete: false)
                            ]
                        ),
                        settings: .init()
                    ),
                    reducer: AppDomain.reducer.debug(),
                    environment: .init(
                        mainScheduler: .main,
                        makeUUID: UUID.init,
                        userDefaults: .standard
                    )
                )
            )
        }
    }
}
