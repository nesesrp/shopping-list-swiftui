import Foundation
import Combine

@MainActor
final class ShoppingListViewModel: ObservableObject {
    @Published private(set) var items: [ShoppingItem] = []
    @Published var searchText: String = ""

    var filteredItems: [ShoppingItem] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return items
        }
        return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var groupedItems: [(category: Category, items: [ShoppingItem])] {
        let grouped = Dictionary(grouping: filteredItems, by: \.category)
        return Category.allCases.compactMap { category in
            guard let items = grouped[category], !items.isEmpty else { return nil }
            return (category, items)
        }
    }

    var hasCheckedItems: Bool {
        items.contains { $0.isChecked }
    }

    private let persistence: PersistenceServiceProtocol

    init(persistence: PersistenceServiceProtocol = PersistenceService()) {
        self.persistence = persistence
        self.items = persistence.load()
    }

    func addItem(name: String, quantity: Int = 1, category: Category = .other) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(ShoppingItem(name: trimmed, quantity: quantity, category: category))
        persist()
    }

    func updateItem(_ item: ShoppingItem, name: String, quantity: Int, category: Category) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items[index].name = trimmed
        items[index].quantity = quantity
        items[index].category = category
        persist()
    }

    func toggleChecked(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isChecked.toggle()
        persist()
    }

    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persist()
    }

    func removeItems(_ itemsToRemove: [ShoppingItem]) {
        let idsToRemove = Set(itemsToRemove.map(\.id))
        items.removeAll { idsToRemove.contains($0.id) }
        persist()
    }

    func clearCheckedItems() {
        items.removeAll { $0.isChecked }
        persist()
    }

    private func persist() {
        persistence.save(items)
    }
}
