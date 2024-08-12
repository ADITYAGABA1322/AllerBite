import SwiftUI
import Lottie

struct OnboardingInfo: Identifiable, Hashable {
    let id = UUID()
  let title: String
  let appName: String
  let logoImageName: String
  let vectorArtImageName: String
}

struct onBoardingContentView: View {
  let info: OnboardingInfo

  var body: some View {
    VStack {
      Image(info.logoImageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .padding(.top)
      Text(info.title)
        .font(.system(size: 47))
        .bold()
      Text(info.appName)
        .font(.system(size: 47))
        .bold()
        .foregroundColor(  Color(red: 79/255, green: 143/255, blue: 0/255))
        Image(info.vectorArtImageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 362, height: 362)
          .padding(.top)
      Spacer()
        HStack {
            ZStack {
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .padding(EdgeInsets(top: 12, leading: 50, bottom: 12, trailing: 50))
                        .foregroundColor(.white)
                        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .cornerRadius(10)
                        .frame(minWidth: 150, minHeight: 50)
                }
            }
          ZStack {
              NavigationLink(destination: RegisterView()) {
              Text("Register")
                .padding(EdgeInsets(top: 12, leading: 50, bottom: 12, trailing: 50))
                .foregroundColor(.white)
                .background(  Color(red: 79/255, green: 143/255, blue: 0/255))
                .cornerRadius(10)
            }
            .frame(minWidth: 150, minHeight: 50)
          }
        }


    }
  }
}

struct onBoardingView: View {
    @State private var showSplash = true
    @AppStorage("isOnboarded") var isOnboarded: Bool = false
    let onboardingData: [OnboardingInfo] = [
        OnboardingInfo(
            title: "Welcome to",
            appName: "AllerBite",
            logoImageName: "logo",
            vectorArtImageName: "launchVector"
        ),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    if showSplash {
                        //                        LottieView(filename: "cart")
                        DisplayView()
                        //                            .frame(width: 300, height: 300)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+2) { // Change the delay as needed
                                    withAnimation {
                                        showSplash = false
                                    }
                                }
                            }
                        
                    }
                    else{
                        TabView {
                            ForEach(onboardingData, id: \.self) { info in
                                onBoardingContentView(info: info)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .fullScreenCover(isPresented: $isOnboarded) {
                            // Your main app view
                        }
                    }
                }
            }
        }
    }
}


struct LottieView: UIViewRepresentable {
    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}


#Preview {
  onBoardingView()
}

