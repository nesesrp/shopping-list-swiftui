import XCTest
@testable import ShoppingList

@MainActor
final class ShoppingListViewModelTests: XCTestCase {
    private var persistence: MockPersistenceService!
    private var sut: ShoppingListViewModel!

    override func setUp() {
        super.setUp()
        persistence = MockPersistenceService()
        sut = ShoppingListViewModel(persistence: persistence)
    }

    override func tearDown() {
        sut = nil
        persistence = nil
        super.tearDown()
    }

    func testInit_loadsItemsFromPersistence() {
        let stored = [ShoppingItem(name: "Süt")]
        persistence.itemsToLoad = stored
        let viewModel = ShoppingListViewModel(persistence: persistence)

        XCTAssertEqual(viewModel.items, stored)
    }

    func testAddItem_appendsItemAndPersists() {
        sut.addItem(name: "Ekmek", quantity: 2, category: .bakery)

        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items.first?.name, "Ekmek")
        XCTAssertEqual(sut.items.first?.quantity, 2)
        XCTAssertEqual(sut.items.first?.category, .bakery)
        XCTAssertEqual(persistence.saveCallCount, 1)
    }

    func testAddItem_trimsWhitespaceAndIgnoresEmptyName() {
        sut.addItem(name: "  Elma  ")
        sut.addItem(name: "   ")

        XCTAssertEqual(sut.items.count, 1)
        XCTAssertEqual(sut.items.first?.name, "Elma")
    }

    func testUpdateItem_updatesFieldsAndPersists() {
        sut.addItem(name: "Süt", quantity: 1, category: .other)
        let item = sut.items[0]

        sut.updateItem(item, name: "Yoğurt", quantity: 3, category: .dairy)

        XCTAssertEqual(sut.items[0].name, "Yoğurt")
        XCTAssertEqual(sut.items[0].quantity, 3)
        XCTAssertEqual(sut.items[0].category, .dairy)
        XCTAssertEqual(sut.items[0].id, item.id)
    }

    func testUpdateItem_ignoresEmptyName() {
        sut.addItem(name: "Süt")
        let item = sut.items[0]

        sut.updateItem(item, name: "   ", quantity: 5, category: .dairy)

        XCTAssertEqual(sut.items[0].name, "Süt")
        XCTAssertEqual(sut.items[0].quantity, 1)
    }

    func testToggleChecked_flipsIsCheckedAndPersists() {
        sut.addItem(name: "Süt")
        let item = sut.items[0]

        sut.toggleChecked(item)
        XCTAssertTrue(sut.items[0].isChecked)

        sut.toggleChecked(item)
        XCTAssertFalse(sut.items[0].isChecked)
    }

    func testRemoveItemsAtOffsets_removesCorrectItems() {
        sut.addItem(name: "Süt")
        sut.addItem(name: "Ekmek")
        sut.addItem(name: "Elma")

        sut.removeItems(at: IndexSet(integer: 1))

        XCTAssertEqual(sut.items.map(\.name), ["Süt", "Elma"])
    }

    func testRemoveItemsByValue_removesMatchingItems() {
        sut.addItem(name: "Süt")
        sut.addItem(name: "Ekmek")
        let toRemove = sut.items.filter { $0.name == "Süt" }

        sut.removeItems(toRemove)

        XCTAssertEqual(sut.items.map(\.name), ["Ekmek"])
    }

    func testClearCheckedItems_removesOnlyCheckedItems() {
        sut.addItem(name: "Süt")
        sut.addItem(name: "Ekmek")
        sut.toggleChecked(sut.items[0])

        sut.clearCheckedItems()

        XCTAssertEqual(sut.items.map(\.name), ["Ekmek"])
    }

    func testHasCheckedItems_reflectsCheckedState() {
        sut.addItem(name: "Süt")
        XCTAssertFalse(sut.hasCheckedItems)

        sut.toggleChecked(sut.items[0])
        XCTAssertTrue(sut.hasCheckedItems)
    }

    func testFilteredItems_filtersCaseInsensitivelyByName() {
        sut.addItem(name: "Süt")
        sut.addItem(name: "Ekmek")

        sut.searchText = "süt"

        XCTAssertEqual(sut.filteredItems.map(\.name), ["Süt"])
    }

    func testFilteredItems_returnsAllItemsWhenSearchTextIsBlank() {
        sut.addItem(name: "Süt")
        sut.addItem(name: "Ekmek")

        sut.searchText = "   "

        XCTAssertEqual(sut.filteredItems.count, 2)
    }

    func testGroupedItems_groupsByCategoryInDeclarationOrder() {
        sut.addItem(name: "Tavuk", category: .meat)
        sut.addItem(name: "Süt", category: .dairy)
        sut.addItem(name: "Yoğurt", category: .dairy)

        let groups = sut.groupedItems

        XCTAssertEqual(groups.map(\.category), [.dairy, .meat])
        XCTAssertEqual(groups.first?.items.map(\.name), ["Süt", "Yoğurt"])
    }

    func testGroupedItems_excludesEmptyCategories() {
        sut.addItem(name: "Süt", category: .dairy)

        let groups = sut.groupedItems

        XCTAssertEqual(groups.count, 1)
    }
}
