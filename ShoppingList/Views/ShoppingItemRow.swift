import SwiftUI

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(item.isChecked ? .green : .secondary)
                .onTapGesture(perform: onToggle)

            VStack(alignment: .leading) {
                Text(item.name)
                    .strikethrough(item.isChecked)
                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                if item.quantity > 1 {
                    Text("x\(item.quantity)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
    }
}

#Preview {
    ShoppingItemRow(item: ShoppingItem(name: "Süt", quantity: 2), onToggle: {}, onEdit: {})
}
