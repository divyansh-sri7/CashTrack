//
//  settingView.swift
//  test2
//
//  Created by Divyansh Srivastava on 24/02/24.
//

import SwiftUI
import FirebaseAuth

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    List{
                        Section{
                            NavigationLink(destination: allTransactions()) {
                                HStack{
                                    Image(systemName: "creditcard.fill")
                                        .frame(width: 30, height: 40)
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.yellow)
                                    Text("Transactions")
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                }
                            }
                            NavigationLink(destination: CombinedAmountByCategory(selected: "car")) {
                                HStack{
                                    Image(systemName: "list.bullet.rectangle")
                                        .frame(width: 30, height: 40)
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.blue)
                                    Text("Categories")
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                }
                            }
                        } header: {
                            Text("Data")
                        }
                        Section{
                            NavigationLink(destination: currencyConversion()) {
                                HStack{
                                    Image(systemName: "dollarsign.square")
                                        .frame(width: 30, height: 40)
                                        .font(.system(size: 25))
                                        .foregroundStyle(Color.pink)
                                    Text("Currency conversion")
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                }
                            }
                        }
                        Section{
                            NavigationLink(destination: SplitBill()) {
                                HStack{
                                    Image(systemName: "banknote")
                                        .frame(width: 30, height: 40)
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.green)
                                    Text("Split the Bill")
                                        .foregroundStyle(Color.primary)
                                    Spacer()
                                }
                            }
                        }
                        
                        Button(action: {
                            isLoading=true
                            let firebaseAuth = Auth.auth()
                            do{
                                try firebaseAuth.signOut()
                                DispatchQueue.main.asyncAfter(deadline: .now()+2)
                                {
                                    UserDefaults.standard.set(false, forKey: "signIn")
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            catch let signOutError as NSError{
                                print("Error signing out : @",signOutError)
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Log Out")
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.red)
                                    .frame(height: 40)
                                Spacer()
                            }
                            
                        }
                    }
                    .navigationTitle("Menu")
                    Text("App Version 2.3.3")
                        .font(.caption2).bold()
                }
                if isLoading{
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.pink)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .fill(Color.gray.opacity(0.3)))
                        .scaleEffect(2.0, anchor: .center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.8) {
                                isLoading=false
                            }
                        }
                }
            }
            .background(Color("colorBG"))
        }
    }
}

#Preview {
    MenuView()
}
