//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var title: String
}

struct SelectedItemKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value ?? nextValue()
    }
}

struct Picker: View {
    @State private var selection: UUID?
    var items = ["Inbox", "Sent", "Archive"].map { Item(title: $0) }
    @Namespace private var namespace

    var body: some View {
        let selectedItem = selection ?? items[0].id
        HStack {
            ForEach(items) { item in
                Button(item.title) {
                    selection = item.id
                }
                .padding(.bottom, 4)
                .anchorPreference(key: SelectedItemKey.self, value: .bounds, transform: { anchor in
                    selectedItem == item.id ? anchor : nil
                })
            }
        }
        .overlayPreferenceValue(SelectedItemKey.self, alignment: .bottom, { value in
            if let anchor = value {
                GeometryReader { proxy in
                    let rect = proxy[anchor]
                    Color.accentColor
                        .frame(width: rect.width)
                        .padding(.leading, rect.minX)
                }
                .frame(height: 1)
            }
        })
        .buttonStyle(.plain)
        .animation(.default, value: selectedItem)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Picker()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
