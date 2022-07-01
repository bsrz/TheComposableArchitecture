import ComposableArchitecture
import SwiftUI

struct TodoListView: View {

    let store: Store<TodoListDomain.State, TodoListDomain.Action>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEachStore(
                        store.scope(
                            state: \.todos,
                            action: TodoListDomain.Action.todo(id:action:)
                        ),
                        content: TodoView.init(store:)
                    )
                }
                .listStyle(.plain)
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
        TodoListView(
            store: .init(
                initialState: .init(
                    todos: [
                        .init(description: "Milk", isComplete: true),
                        .init(description: "Eggs", isComplete: false),
                        .init(description: "Hand Soap", isComplete: false)
                    ]
                ),
                reducer: TodoListDomain.reducer,
                environment: .init(
                    mainScheduler: .main,
                    makeUUID: UUID.init
                )
            )
        )
    }
}

