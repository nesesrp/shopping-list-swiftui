import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var isPresentingAddItem = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredItems) { item in
                    ShoppingItemRow(item: item) {
                        viewModel.toggleChecked(item)
                    }
                }
                .onDelete { offsets in
                    let itemsToRemove = offsets.map { viewModel.filteredItems[$0] }
                    viewModel.removeItems(itemsToRemove)
                }
            }
            .navigationTitle("Alışveriş Listesi")
            .searchable(text: $viewModel.searchText, prompt: "Ürün ara")
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
                if viewModel.filteredItems.isEmpty {
                    if viewModel.searchText.isEmpty {
                        ContentUnavailableView(
                            "Liste Boş",
                            systemImage: "cart",
                            description: Text("Eklemek için sağ üstteki + butonuna dokun.")
                        )
                    } else {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    }
                }
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
