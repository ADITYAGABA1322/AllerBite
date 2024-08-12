import SwiftUI

struct DisplayView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color(red: 165/255, green: 205/255, blue: 58/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isAnimating ? 300 : 0, height: isAnimating ? 300 : 0) // Initial size is 0
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0)) // Rotate if animating
                    .scaleEffect(isAnimating ? 2 : 1) // Scale up if animating
                    .opacity(isAnimating ? 1 : 0) // Make visible if animating
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            self.isAnimating = true // Start animation on appear
                        }
                    }
                
                Spacer()
            }
        }
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}
