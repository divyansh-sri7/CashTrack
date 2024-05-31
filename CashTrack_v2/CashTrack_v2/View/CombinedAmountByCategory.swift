//
//  CombinedAmountByCategory.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 25/04/24.
//
import SwiftUI

struct CombinedAmountByCategory: View {
    @ObservedObject var transactionVM = transactionData()
    @State var selected: String = "car"
    @State var showTransactions = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Expenses")) {
                    ForEach(transactionVM.combinedAmountsByExpenseCategory().sorted(by: { $0.value > $1.value }), id: \.0) { category, amount in
                        categoryRow(category: category, amount: amount, isExpense: true)
                    }
                }

                Section(header: Text("Income")) {
                    ForEach(transactionVM.combinedAmountsByIncomeCategory().sorted(by: { $0.value > $1.value }), id: \.0) { category, amount in
                        categoryRow(category: category, amount: amount, isExpense: false)
                    }
                }
            }
            .navigationTitle("Categories")
            .onAppear {
                transactionVM.fetchData()
            }
            .sheet(isPresented: $showTransactions) {
                TransactionsByCategory(selected: $selected)
            }
        }
    }

    @ViewBuilder
    private func categoryRow(category: String, amount: Float, isExpense: Bool) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(categoryInfo[category]!.color)
                Image(systemName: categoryInfo[category]!.icon)
                    .foregroundStyle(Color.white)
            }
            Text(categoryInfo[category]!.categoryName)
            Spacer()
            Text((isExpense ? "-" : "+") + String(format: "%.2f", amount))
                .foregroundStyle(isExpense ? Color.red : Color.green)
        }
        .contentShape(Rectangle()) // Ensure the entire row is tappable
        .onTapGesture {
            selected = category
            showTransactions.toggle()
        }
    }
}

#Preview {
    CombinedAmountByCategory(selected: "car")
}
