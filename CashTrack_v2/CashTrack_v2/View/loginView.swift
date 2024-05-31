
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct loginView: View {
    
    //MARK: - variables
    
    @State private var username:String=""
    @State private var password:String=""
    @State private var signUpclicked = false
    @State private var signinclicked = false
    @State private var signedin = false
    @State private var showText = false
    @State private var showAlert = false
    @State private var isLoading = false
    @ObservedObject var transactionVM:transactionData = transactionData()
    
    //MARK: - view
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack{
                    Spacer()
                    //MARK: - headings
                    
                    Text("Sign In")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .frame(width:330,alignment: .leading)
                        .padding(.bottom,10)
                    Text("Sign in to Continue!")
                        .fontWeight(.semibold)
                        .frame(width:330,alignment: .leading)
                    
                    //MARK: - email authentication fields
                    
                    HStack{
                        Image(systemName: "person")
                            .font(.system(size: 30))
                            .padding(.trailing)
                        TextField("Username", text: $username)
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
                            TextField("Password", text: $password)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.none)
                        }
                        else{
                            SecureField("Password", text: $password)
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
                    
                    NavigationLink(destination: HomeScreen(),isActive: $signinclicked) {
                        Button(action:{
                            Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                                if let e = error{
                                    showAlert.toggle()
                                    print(e)
                                }
                                else
                                {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                        isLoading = true
                                        UserDefaults.standard.set(true, forKey: "signIn")
                                        signinclicked=true
                                    }
                                }
                            }
                        },label: {
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .frame(width: 330,height: 50)
                                    .foregroundStyle(Color.pink)
                                
                                Text("Sign In")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.white)
                            }
                        })
                        
                        .padding(.bottom,10)
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Wrong Username or Password!"))
                        })
                    }
                    .isDetailLink(false)
                    
                    //MARK: - divider
                    
                    Divider()
                        .frame(height: 0.3)
                        .overlay(.gray)
                        .padding(.horizontal,30)
                        .padding(.bottom,10)
                    
                    Text("or login with")
                        .opacity(0.8)
                    
                    //MARK: - login with google
                    
                    Button(action:{
                        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config
                        
                        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                            guard error == nil else {
                                return
                            }
                            guard let user = result?.user,
                                  let idToken = user.idToken?.tokenString
                            else {
                                return
                            }
                            
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                           accessToken: user.accessToken.tokenString)
                            
                            Auth.auth().signIn(with: credential) { result, error in
                            }
                            isLoading=true
                            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                UserDefaults.standard.set(true, forKey: "signIn")
                                signedin=true
                            }
                        }
                    }){
                        Buttons(title: "Log in with Google", image: .googleLogo)
                    }
                    .navigationDestination(isPresented: $signedin) {
                        HomeScreen()
                    }

                    Spacer()
                    
                    //MARK: - sign up
                    
                    HStack{
                        Text("Don't have an Account?")
                        Button(action:{
                            signUpclicked=true
                        }){
                            Text("Sign up")
                                .foregroundStyle(.pink)
                        }
                        .navigationDestination(isPresented: $signUpclicked) {
                            signUpView()
                        }
                    }
                    .padding(.vertical)
                    
                }
                .navigationBarBackButtonHidden(true)
                if isLoading{
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.pink)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .fill(Color.gray.opacity(0.3)))
                        .scaleEffect(2.0, anchor: .center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.8) {
                                isLoading=false
                            }
                        }
                }
            }
            .background(Color("colorBG"))
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

extension View{
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: - preview

#Preview {
    loginView()
}

//MARK: - subview for button

struct Buttons: View {
    var title:String
    var image:UIImage
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 30,height: 30)
                .scaledToFit()
                .padding(.horizontal)
            Spacer()
            Text(title)
                .font(.title2)
                .fontWeight(.regular)
                .foregroundStyle(.black)
            Spacer()
        }
        .padding()
        .frame(maxWidth: 330,maxHeight: 50)
        .background(Color.white)
        .overlay(Color.gray.opacity(0.1))
        .cornerRadius(10.0)
        .shadow(color: Color.black.opacity(0.1),radius: 60,x: 0.0,y: 16)
        .padding(.vertical,10)
    }
}
