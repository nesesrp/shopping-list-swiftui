import Foundation

protocol PersistenceServiceProtocol {
    func load() -> [ShoppingItem]
    func save(_ items: [ShoppingItem])
}

final class PersistenceService: PersistenceServiceProtocol {
    private let key = "shopping_items"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> [ShoppingItem] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([ShoppingItem].self, from: data)) ?? []
    }

    func save(_ items: [ShoppingItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: key)
    }
}
