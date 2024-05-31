//
//  addTransactionAfterSplit.swift
//  CashTrack_v2
//
//  Created by Divyansh Srivastava on 25/04/24.
//


import SwiftUI

struct AddTransactionAfterSplit: View {
    @EnvironmentObject var appVM: AppViewModel
    @State var final : String = "empty"
    @State var add_amount: Float
    @State var date: Date = Date()
    @State var note: String = ""
    @State var selectedType: CategoryType = .expense
    @State var showCategorieView : Bool = false
    @State var tvm : transactionData = transactionData()
    @State private var isInputValid = false
    @Environment(\.dismiss) var dismiss
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Section {
                        TextField(selectedType == .expense ? "-100" : "+100", value: $add_amount, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                            
                    } header: {
                        Text("Enter amount:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    Section {
                        TextField("Note", text: $note)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                    } header: {
                        Text("Enter note:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    
                    Section {
                        NavigationLink(destination: showCategories(selectedCategoryType: selectedType,final:
                                                                  $final)) {
                            HStack{
                                if final=="empty"{
                                    HStack {
                                        Spacer()
                                        Text("?")
                                            .font(.system(size: 15))
                                            .frame(width: 35, height: 35)
                                            .foregroundStyle(Color.primary)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                                    .strokeBorder(Color.primary)
                                            }
                                        
                                        Text("Select a category")
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                    }
                                    .font(Font.subheadline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(Color.gray).opacity(0.25))
                                    .cornerRadius(10)
                                }
                                else{
                                    HStack {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10.0)
                                                .frame(width: 40,height: 40)
                                                .foregroundStyle(categoryInfo[final]?.color ?? Color.gray)
                                            Image(systemName: categoryInfo[final]!.icon)
                                                .foregroundStyle(Color.white)
                                        }
                                        Text(categoryInfo[final]!.categoryName)
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                    }
                                    .foregroundStyle(Color("colorBalanceBG"))
                                    .padding(5)
                                }
                            }
                        }
                        
                    } header: {
                        Text("Category:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    Section {
                        HStack {
                            DatePicker("Date", selection: $date, displayedComponents: .date)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                    } header: {
                        Text("Enter date:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)

            }
            .scrollDismissesKeyboard(.immediately)
            .background(Color("colorBG"))
            .navigationBarTitle("Addendum", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        tvm.addTransaction(transaction: transactionModel(category: final, amount: Float(add_amount), categoryType: selectedType, note: note,date: date))
                        dismiss()
                    } label: {
                        Text("Add")
                    }
                    .disabled(!isInputValid)
                    .onChange(of: final) { _ in
                        validateInput() // Validate input when category changes
                    }
                }
            }
        }
    }
    private func validateInput() {
        let isCategoryValid = !final.isEmpty
        let isAmountValid = Float(add_amount) != 0
        isInputValid = isCategoryValid && isAmountValid
        
    }
}
#Preview {
    AddTransactionAfterSplit(add_amount: 0)
}

