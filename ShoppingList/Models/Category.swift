import Foundation

enum Category: String, CaseIterable, Codable, Identifiable {
    case dairy = "Süt Ürünleri"
    case produce = "Meyve & Sebze"
    case meat = "Et & Tavuk"
    case bakery = "Fırın"
    case beverages = "İçecek"
    case cleaning = "Temizlik"
    case snacks = "Atıştırmalık"
    case other = "Diğer"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dairy: return "carton.fill"
        case .produce: return "leaf.fill"
        case .meat: return "fork.knife"
        case .bakery: return "birthday.cake.fill"
        case .beverages: return "cup.and.saucer.fill"
        case .cleaning: return "sparkles"
        case .snacks: return "popcorn.fill"
        case .other: return "cart.fill"
        }
    }
}
