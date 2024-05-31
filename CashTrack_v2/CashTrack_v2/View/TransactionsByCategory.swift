//
//  TranasctionsByCategory.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 01/05/24.
//

import SwiftUI

struct TransactionsByCategory: View {
    @ObservedObject var transactionVM = transactionData()
    @Binding var selected: String

    var body: some View {
        NavigationView {
            List(transactionVM.transactions.filter { $0.category == selected }.sorted(by: { $0.date > $1.date })) { transaction in
                TransactionRow(transaction: transaction)
            }
            .navigationTitle(selected)
            .onAppear {
                transactionVM.fetchData()
            }
        }
    }
}

private struct TransactionRow: View {
    var transaction: transactionModel

    var body: some View {
        VStack {
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(categoryInfo[transaction.category]?.color ?? Color.gray)
                    Image(systemName: categoryInfo[transaction.category]!.icon)
                        .foregroundStyle(Color.white)
                }
                Text(transaction.category)
                Spacer()
                Text(transaction.categoryType == .expense ? "-"+String(format: "%.2f", transaction.amount) : "+"+String(format: "%.2f", transaction.amount))
                    .foregroundStyle(transaction.categoryType == .expense ? Color.red : Color.green)
            }
            HStack{
                Text("Date : ")
                Text(formattedDate(transaction.date))
                Spacer()
            }
            HStack{
                Text("Note : ")
                Text(transaction.note)
                Spacer()
            }
        }
    }
}

private func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}
#Preview {
    TransactionsByCategory(selected: .constant("Food"))
}
