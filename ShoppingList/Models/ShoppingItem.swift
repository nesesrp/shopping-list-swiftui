import Foundation

struct ShoppingItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var quantity: Int
    var isChecked: Bool
    var category: Category

    init(id: UUID = UUID(), name: String, quantity: Int = 1, isChecked: Bool = false, category: Category = .other) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
        self.category = category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(Int.self, forKey: .quantity)
        isChecked = try container.decode(Bool.self, forKey: .isChecked)
        category = try container.decodeIfPresent(Category.self, forKey: .category) ?? .other
    }
}
