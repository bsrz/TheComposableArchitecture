import ComposableArchitecture
import SwiftUI

struct AppView: View {

    let store: Store<AppDomain.State, AppDomain.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.onboarding == nil {
                TabView {
                    TodoListView(
                        store: store.scope(
                            state: \.todoList,
                            action: AppDomain.Action.todoList
                        )
                    )
                    .tabItem {
                        HStack {
                            Image(systemName: "checklist")
                            Text("Todos")
                        }
                    }

                    SettingsView(
                        store: store.scope(
                            state: \.settings,
                            action: AppDomain.Action.settings
                        )
                    )
                    .tabItem {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                }
                .onAppear { viewStore.send(.onAppear) }
                .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            } else {
                IfLetStore(
                    store.scope(
                        state: \.onboarding,
                        action: AppDomain.Action.onboarding
                    ),
                    then: OnboardingView.init(store:)
                )
                .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
}
