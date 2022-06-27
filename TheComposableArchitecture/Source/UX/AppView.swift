import ComposableArchitecture
import SwiftUI

struct AppView: View {

    let store: Store<AppDomain.State, AppDomain.Action>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEachStore(
                        store.scope(
                            state: \.todos,
                            action: AppDomain.Action.todo(index:action:)
                        ),
                        content: TodoView.init(store:)
                    )
                }
                .navigationTitle("Todos")
                .navigationBarItems(
                    trailing: Button("Add") {
                        viewStore.send(.add)
                    }
                )
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: .init(
                    todos: [
                        .init(description: "Milk", isComplete: true),
                        .init(description: "Eggs", isComplete: false),
                        .init(description: "Hand Soap", isComplete: false)
                    ]
                ),
                reducer: AppDomain.reducer,
                environment: .init()
            )
        )
    }
}

