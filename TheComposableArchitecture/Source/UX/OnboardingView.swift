import ComposableArchitecture
import SwiftUI

struct OnboardingView: View {

    let store: Store<OnboardingDomain.State, OnboardingDomain.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.step == .welcome {
                    Text("Welcome")
                        .padding()
                }
                if viewStore.step == .firstName {
                    TextField(
                        "What's your first name?",
                        text: viewStore.binding(
                            get: \.user.firstName,
                            send: OnboardingDomain.Action.firstName
                        )
                    )
                    .padding()
                }
                if viewStore.step == .lastName {
                    TextField(
                        "What's your last name?",
                        text: viewStore.binding(
                            get: \.user.lastName,
                            send: OnboardingDomain.Action.lastName
                        )
                    )
                    .padding()
                }
                if viewStore.step == .email {
                    TextField(
                        "What's your email?",
                        text: viewStore.binding(
                            get: \.user.email,
                            send: OnboardingDomain.Action.email
                        )
                    )
                    .padding()
                }

                Button("Next") {
                    viewStore.send(.next)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: .init(
                initialState: .init(step: .firstName),
                reducer: OnboardingDomain.reducer,
                environment: .init(userDefaults: .standard)
            )
        )
    }
}

