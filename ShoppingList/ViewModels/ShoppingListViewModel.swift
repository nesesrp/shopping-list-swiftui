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

    private let persistence: PersistenceServiceProtocol

    init(persistence: PersistenceServiceProtocol = PersistenceService()) {
        self.persistence = persistence
        self.items = persistence.load()
    }

    func addItem(name: String, quantity: Int = 1) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(ShoppingItem(name: trimmed, quantity: quantity))
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

    private func persist() {
        persistence.save(items)
    }
}
