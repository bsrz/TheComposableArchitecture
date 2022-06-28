import ComposableArchitecture
import SwiftUI

struct TodoView: View {

    let store: Store<Todo, TodoDomain.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button {
                    withAnimation {
                        viewStore.send(.checkboxTapped)
                    }
                } label: {
                    Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(.plain)

                TextField(
                    "untitled",
                    text: viewStore.binding(
                        get: \.description,
                        send: TodoDomain.Action.textFieldChange
                    )
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
        }
    }
}
