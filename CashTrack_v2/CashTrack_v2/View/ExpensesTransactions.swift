//
//  ExpensesTransactions.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 19/04/24.
//

import SwiftUI

struct ExpensesTransactions: View {
    @ObservedObject var transactionVM:transactionData = transactionData()
    @State var category = Category()
    var body: some View {
                NavigationView {
                    List(transactionVM.transactions) { transaction in
                        if(transaction.categoryType == .expense){
                            TransactionRow(transaction: transaction)
                        }
                    }
                    .navigationTitle("Expenses")
                    .onAppear {
                        transactionVM.fetchData()
                    }
                }

    }
}


private struct TransactionRow: View {
    var transaction: transactionModel

    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(width: 40)
                    .foregroundStyle(categoryInfo[transaction.category]?.color ?? Color.gray)
                Image(systemName: categoryInfo[transaction.category]!.icon)
                    .foregroundStyle(Color.white)
            }
            Text(transaction.category)
            Spacer()
            Text("-"+String(format: "%.2f", transaction.amount))
        }
    }
}
#Preview {
    ExpensesTransactions()
}

