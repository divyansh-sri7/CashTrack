//
//  signUpView.swift
//  test2
//
//  Created by Divyansh Srivastava on 23/02/24.
//

import SwiftUI
import FirebaseAuth

struct signUpView: View {
    
    //MARK: - varibales

    @State private var email:String = ""
    @State private var pass:String = ""
    @State private var signedUp = false
    @State private var showText = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var errorMessage = "Error!"
    
    //MARK: - view
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color("colorBG")
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    
                    //MARK: - headings
                    
                    
                    Text("Sign Up")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .frame(width:330,alignment: .leading)
                        .padding(.bottom,10)
                    Text("Create new account!")
                        .fontWeight(.semibold)
                        .frame(width:330,alignment: .leading)
                    
                    //MARK: - email and password textfields
                    
                    HStack{
                        Image(systemName: "person")
                            .font(.system(size: 30))
                            .padding(.trailing)
                        TextField("Email Id", text: $email)
                            .zIndex(1.0)
                    }
                    .padding()
                    .frame(maxWidth: 330)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10.0)
                    .shadow(color: Color.black.opacity(0.1),radius: 60,x: 0.0,y: 16)
                    .padding(.top,10)
                    HStack {
                        Image(systemName: "lock")
                            .font(.system(size: 30))
                            .padding(.trailing)
                        if showText{
                            TextField("Password", text: $pass)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.none)
                        }
                        else{
                            SecureField("Password", text: $pass)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.none)
                        }
                        Button {
                            showText.toggle()
                        } label: {
                            Image(systemName: showText ? "eye.fill" : "eye.slash.fill")
                                .foregroundStyle(Color.gray)
                        }

                    }
                    .padding()
                    .frame(maxWidth: 330)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10.0)
                    .shadow(color: Color.black.opacity(0.1),radius: 60,x: 0.0,y: 16)
                    .padding(.bottom,5)
                    
                    
                    //MARK: - sign up button
                    
                    
                    NavigationLink(destination: loginView(),isActive: $signedUp,label: {
                        Button(action:{
                            
                            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                                if let e = error{
                                    errorMessage=e.localizedDescription
                                    showAlert.toggle()
                                    print(e)
                                }
                                else
                                {
                                    isLoading=true
                                    UserDefaults.standard.set(true, forKey: "signIn")
                                    signedUp = true
                                }
                            }
                        }){
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .frame(width: 330,height: 50)
                                    .foregroundStyle(Color.pink)
                                
                                Text("Sign Up")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding(.bottom,10)
                    })
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text(errorMessage))
                    })
                    Spacer()
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                isLoading=false
                            }
                        }
                }
            }
            
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

//MARK: - preview

#Preview {
    signUpView()
}
