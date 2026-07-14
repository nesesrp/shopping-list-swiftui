import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var quantity: Int = 1

    let onAdd: (String, Int) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Ürün adı", text: $name)
                Stepper("Adet: \(quantity)", value: $quantity, in: 1...99)
            }
            .navigationTitle("Yeni Ürün")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ekle") {
                        onAdd(name, quantity)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddItemView(onAdd: { _, _ in })
}
