import SwiftUI

struct showCategories: View {
    @State var selectedCategoryType: CategoryType
    @State var selectedCategory: String = ""
    @Binding var final : String
    @State var category = Category()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            if selectedCategoryType == .expense{
                List(category.expenseCategories, id: \.self) { category in
                    CategoryRow(eachCategory: category, isSelected: selectedCategory == category) { selected in
                        final = selected ? category : ""
                        dismiss()
                    }
                }
                .navigationTitle("Expenses")
            }
            else{
                List(category.incomeCategories, id: \.self) { category in
                    CategoryRow(eachCategory: category, isSelected: selectedCategory == category) { selected in
                        final = selected ? category : ""
                        dismiss()
                    }
                }
                .navigationTitle("Income")
            }
        }
    }
}

private struct CategoryRow: View {
    var eachCategory: String
    var isSelected: Bool
    var action: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            action(!isSelected)
            
        }) {
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 40)
                        .foregroundStyle(categoryInfo[eachCategory]?.color ?? Color.gray)
                    Image(systemName: categoryInfo[eachCategory]!.icon)
                        .foregroundStyle(Color.white)
                }
                Text(categoryInfo[eachCategory]!.categoryName)
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    showCategories(selectedCategoryType: .expense,final: .constant("empty"))
}
