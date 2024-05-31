
import SwiftUI

struct SplashScreen: View {
    @State private var scale = CGSize(width: 1, height: 1)
    var body: some View {
        ZStack{
            Color("colorBG")
                .ignoresSafeArea(.all)
            Text("CashTrack")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(Color.pink)
        }
        .scaleEffect(scale)
        .onAppear{
            withAnimation(.easeInOut(duration: 1)){
                scale = CGSize(width: 1.5, height: 1.5)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
