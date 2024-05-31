//
//  test2App.swift
//  test2
//
//  Created by Divyansh Srivastava on 16/02/24.
//
import SwiftUI

@main
struct CashTrack_v2: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("signIn") var isSignIn = false
    @State private var showSplash=true

  var body: some Scene {
    WindowGroup {
        ZStack{
            if showSplash{
                SplashScreen()
                    .transition(.opacity)
                    .animation(.easeInOut, value: 1)
            }
            else{
                if !isSignIn{
                    loginView()
                }
                else{
                    HomeScreen()
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+1.8){
                withAnimation{
                    showSplash=false
                }
            }
        }
    }
  }
}
