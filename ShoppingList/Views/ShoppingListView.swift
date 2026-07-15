import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var isPresentingAddItem = false
    @State private var editingItem: ShoppingItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.groupedItems, id: \.category) { group in
                    Section {
                        ForEach(group.items) { item in
                            ShoppingItemRow(
                                item: item,
                                onToggle: { viewModel.toggleChecked(item) },
                                onEdit: { editingItem = item }
                            )
                        }
                        .onDelete { offsets in
                            let itemsToRemove = offsets.map { group.items[$0] }
                            viewModel.removeItems(itemsToRemove)
                        }
                    } header: {
                        Label(group.category.rawValue, systemImage: group.category.icon)
                    }
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
                ToolbarItem(placement: .secondaryAction) {
                    Button(role: .destructive) {
                        viewModel.clearCheckedItems()
                    } label: {
                        Label("İşaretlenenleri Temizle", systemImage: "trash")
                    }
                    .disabled(!viewModel.hasCheckedItems)
                }
            }
            .sheet(isPresented: $isPresentingAddItem) {
                AddItemView { name, quantity, category in
                    viewModel.addItem(name: name, quantity: quantity, category: category)
                }
            }
            .sheet(item: $editingItem) { item in
                AddItemView(editingItem: item) { name, quantity, category in
                    viewModel.updateItem(item, name: name, quantity: quantity, category: category)
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
