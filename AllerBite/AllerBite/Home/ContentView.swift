import SwiftUI
struct ContentView: View {
    @State private var showSplash = true
    @State private var selection = 0
    @State private var isSettingViewActive = false
    @State private var isMainViewActive = false
    @State var isActive: Bool = false
    @GestureState private var dragOffset: CGSize = .zero
    @State private var selectedTab = 0
    @State private var isSheetVisible = false
    @State private var userName: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    ScrollView {
                        VStack {
                            ArtWork()
                        }
                        
                        Spacer() // Push the TabView to the bottom of the screen
                    }
                    
                    // Bottom View with Buttons
                    VStack {
                        // Bottom Bar with Glass Morphism Effect
                        ZStack {
                            // Background color with opacity
                            Color.clear // Use clear color to make it invisible
                            
                            // Blur effect
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .opacity(0.5) // Adjust opacity of the blur effect
                            
                            // Bottom bar content
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.0)]), startPoint: .top, endPoint: .bottom))
                                .frame(height: 120)
                        }
                        .frame(height: 80)
                        .offset(y: 40)
                    }
                    
                    TabView(selection: $selection) {
                        // Home Tab
                        
                        HomeView(userName: "Aditya Gaba")
                            .offset(y:0)
                            .tabItem {
                                CustomTabItem(imageName: "house.fill", text: "Home")
                                
                            }
                            .tag(0)
                        
                        // Scanner Tab
                        
                        BarcodeTextScannerView()
                        
                            .tabItem {
                                CustomTabItem(imageName: "barcode.viewfinder", text: "Scanner")
                                
                            }
                            .tag(1)
                        
                        // Browse Tab
                        HealthPlannerContentView()
                            .tabItem {
                                CustomTabItem(imageName: "square.grid.2x2.fill", text: "Browse")
                            }
                            .tag(2)
                    }
                    
                    .accentColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    
                    
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview{
    ContentView()
}
