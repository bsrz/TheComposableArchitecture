import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .init(
                        todos: [
                            .init(description: "Milk", isComplete: true),
                            .init(description: "Eggs", isComplete: false),
                            .init(description: "Hand Soap", isComplete: false)
                        ]
                    ),
                    reducer: AppDomain.reducer.debug(),
                    environment: .init()
                )
            )
        }
    }
}
