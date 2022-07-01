import ComposableArchitecture
import SwiftUI

struct SettingsView: View {

    let store: Store<SettingsDomain.State, SettingsDomain.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Text("Settings")
                        .font(.largeTitle)

                    Spacer()
                }

                Spacer()

                Button("Log Out") {
                    viewStore.send(.delegate(.logout))
                }
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: .init(
                initialState: .init(),
                reducer: SettingsDomain.reducer,
                environment: .init()
            )
        )
    }
}

