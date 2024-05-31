//
//  SplitBill.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 25/04/24.
//

import SwiftUI

struct SplitBill: View {
    @State var totalCost = ""
    @State var people = 0
    @State var tipIndex = 0
    @State var showAddTransaction : Bool = false
    let tipPercentages = [0, 5, 10, 15]
    
    func calculateTotal() -> Double {
        let tip = Double(tipPercentages[tipIndex])
        let orderTotal = Double(totalCost) ?? 0
        let finalAmount = ((orderTotal / 100 * tip) + orderTotal)
        if people == 0 {
            return finalAmount
        }
        return finalAmount / Double(people+1)
    }
    
    var body: some View {
        NavigationStack {
                Form {
                    Section(header: Text("Enter the Amount")) {
                        TextField("Amount", text: $totalCost)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("Select a tip amount (%)")) {
                        Picker("Tip Percentage", selection: $tipIndex) {
                            ForEach(0 ..< tipPercentages.count) {
                                Text("\(tipPercentages[$0])%")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Section(header: Text("How Many People?")) {
                        Picker("Number Of People", selection: $people) {
                            ForEach(1 ..< 26) { // Adjusted range
                                Text("\($0) People")
                            }
                        }
                    }
                    Section(header: Text("Total per person")) {
                        Text("\(calculateTotal(), specifier: "%.2f")")
                    }
                    Button(action: {
                        showAddTransaction.toggle()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Add to Transactions")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.pink)
                            Spacer()
                        }
                        .frame(height: 40)
                    })
                }
                .navigationTitle("Split the Bill")
            
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionAfterSplit(add_amount: Float(calculateTotal()))
                .onDisappear(){
                    dismissKeyboard()
                }
        }
    }
}

#Preview {
    SplitBill()
}
