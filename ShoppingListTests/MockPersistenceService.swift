import Foundation
@testable import ShoppingList

final class MockPersistenceService: PersistenceServiceProtocol {
    private(set) var savedItems: [ShoppingItem] = []
    private(set) var saveCallCount = 0
    var itemsToLoad: [ShoppingItem] = []

    func load() -> [ShoppingItem] {
        itemsToLoad
    }

    func save(_ items: [ShoppingItem]) {
        savedItems = items
        saveCallCount += 1
    }
}
