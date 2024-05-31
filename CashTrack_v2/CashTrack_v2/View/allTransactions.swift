import SwiftUI

struct allTransactions: View {
    @ObservedObject var transactionVM = transactionData()
    @State private var showingDeleteAlert = false
    @State private var deletionIndexSet: IndexSet?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactionVM.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .onDelete { indexSet in
                                    // Set the index set for deletion
                                    self.deletionIndexSet = indexSet
                                    // Show delete confirmation alert
                                    self.showingDeleteAlert = true
                                }
            }
            .navigationTitle("Transactions")
            .onAppear {
                transactionVM.fetchData()
            }
            .toolbar {
                EditButton()
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Transaction"),
                message: Text("Are you sure you want to delete this transaction?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete")) {
                    if let deletionIndexSet = self.deletionIndexSet {
                        transactionVM.deleteTransaction(at: deletionIndexSet)
                    }
                }
            )
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

struct AllTransactions_Previews: PreviewProvider {
    static var previews: some View {
        allTransactions()
    }
}
