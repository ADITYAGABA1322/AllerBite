import SwiftUI



struct BarcodeTextScannerView: View {
    @StateObject private var vm = AppViewModel()

    var body: some View {
    AllergyView()
        
            .environmentObject(vm)
            .task {
                await vm.requestDataScannerAccessStatus()
            }
    }
}
struct BarcodeTextScannerApp: App {
    @State private var selection = 0
 //   @StateObject private var vm = AppViewModel()
    var body: some Scene {
        WindowGroup {
            BarcodeTextScannerView()

            .accentColor(.blue)
        }
    }
}


