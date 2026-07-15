import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var quantity: Int
    @State private var category: Category

    private let isEditing: Bool
    let onSave: (String, Int, Category) -> Void

    init(editingItem: ShoppingItem? = nil, onSave: @escaping (String, Int, Category) -> Void) {
        self.isEditing = editingItem != nil
        self.onSave = onSave
        _name = State(initialValue: editingItem?.name ?? "")
        _quantity = State(initialValue: editingItem?.quantity ?? 1)
        _category = State(initialValue: editingItem?.category ?? .other)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Ürün adı", text: $name)
                Stepper("Adet: \(quantity)", value: $quantity, in: 1...99)
                Picker("Kategori", selection: $category) {
                    ForEach(Category.allCases) { category in
                        Label(category.rawValue, systemImage: category.icon).tag(category)
                    }
                }
            }
            .navigationTitle(isEditing ? "Ürünü Düzenle" : "Yeni Ürün")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Kaydet" : "Ekle") {
                        onSave(name, quantity, category)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddItemView(onSave: { _, _, _ in })
}
