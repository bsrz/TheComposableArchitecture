import ComposableArchitecture
import SwiftUI

struct AppView: View {

    let store: Store<AppDomain.State, AppDomain.Action>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEach(Array(viewStore.todos.enumerated()), id: \.element.id) { index, todo in
                        HStack {
                            Button {
                                viewStore.send(.todoCheckboxTapped(index: index))
                            } label: {
                                Image(systemName: todo.isComplete ? "checkmark.square" : "square")
                            }
                            .buttonStyle(.plain)

                            TextField(
                                "untitled",
                                text: viewStore.binding(
                                    get: { $0.todos[index].description },
                                    send: { .todoTextFieldChanged(index: index, text: $0)}
                                )
                            )
                        }
                        .foregroundColor(todo.isComplete ? .gray : nil)
                    }
                }
                .navigationTitle("Todos")
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

