import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var isPresentingAddItem = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    ShoppingItemRow(item: item) {
                        viewModel.toggleChecked(item)
                    }
                }
                .onDelete(perform: viewModel.removeItems)
            }
            .navigationTitle("Alışveriş Listesi")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddItem = true
                    } label: {
                        Label("Ekle", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddItem) {
                AddItemView { name, quantity in
                    viewModel.addItem(name: name, quantity: quantity)
                }
            }
            .overlay {
                if viewModel.items.isEmpty {
                    ContentUnavailableView(
                        "Liste Boş",
                        systemImage: "cart",
                        description: Text("Eklemek için sağ üstteki + butonuna dokun.")
                    )
                }
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
