import SwiftUI
import VisionKit
import AVFoundation
import GoogleGenerativeAI

struct DataScannerView: UIViewControllerRepresentable {
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var showAlert: Bool
    @Binding var navigateToProfileView: Bool
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    var cameraCapture: CameraPhotoCapture
    @Binding var selectedAllergies: Set<String>
    @Binding var responseText: String

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        vc.delegate = context.coordinator
        context.coordinator.dataScanner = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if navigateToProfileView {
            uiViewController.stopScanning()
        } else {
            try? uiViewController.startScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            recognizedItems: $recognizedItems,
            showAlert: $showAlert,
            navigateToProfileView: $navigateToProfileView,
            cameraCapture: cameraCapture,
            selectedAllergies: selectedAllergies,
            responseText: $responseText
        )
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItems: [RecognizedItem]
        @Binding var showAlert: Bool
        @Binding var navigateToProfileView: Bool
        var capturedImage: UIImage?
        var cameraCapture: CameraPhotoCapture
        var selectedAllergies: Set<String>
        var dataScanner: DataScannerViewController?
        @Binding var responseText: String

        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToProfileView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>) {
            self._recognizedItems = recognizedItems
            self._showAlert = showAlert
            self._navigateToProfileView = navigateToProfileView
            self.cameraCapture = cameraCapture
            self.selectedAllergies = selectedAllergies
            self._responseText = responseText
            super.init()
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            print("Selected Allergies: \(selectedAllergies)")
            for item in addedItems {
                switch item {
                case .text(let text):
                    Task {
                        await checkForAllergens(text.transcript)
                    }
                default:
                    break
                }
            }
        }

        func checkForAllergens(_ text: String) async {
            do {
                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default
                )
              
                let allergiesPrompt = selectedAllergies.isEmpty
                    ? "Analyze the ingredients."
                    : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."
                
                let chatSession = model.startChat(history: [])
                let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
                self.responseText = response.text ?? "No response received"
                
                print("Gemini response: \(self.responseText)")

                if response.text?.containsAllergen(for: selectedAllergies) ?? false {
                    print("Allergen detected!")
                    showAlert = true
                    showImageCaptureAndNavigateToProfile(dataScanner: dataScanner)
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error: \(error.localizedDescription)"
                }
                print("Error during allergen check: \(error.localizedDescription)")
            }
        }

        private func showImageCaptureAndNavigateToProfile(dataScanner: DataScannerViewController?) {
            DispatchQueue.main.async {
                Task {
                    do {
                        guard let dataScanner = dataScanner else {
                            print("DataScanner is nil")
                            return
                        }
                        let image = try await dataScanner.capturePhoto()
                        let url = try FileManager.default
                            .url(for: .documentDirectory,
                                 in: .userDomainMask,
                                 appropriateFor: nil,
                                 create: true)
                            .appendingPathComponent("preview.jpeg")
                        if let data = image.jpegData(compressionQuality: 0.9) {
                            try data.write(to: url)
                        }

                        self.cameraCapture.capturedImage = image
                        self.navigateToProfileView = true
                    } catch {
                        print("Error capturing photo: \(error.localizedDescription)")
                    }
                }
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: { $0.id == item.id })
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("became unavailable with error \(error.localizedDescription)")
        }
    }
}

extension String {
    func containsAllergen(for allergens: Set<String>) -> Bool {
        for allergen in allergens {
            if self.localizedCaseInsensitiveContains(allergen) {
                return true
            }
        }
        return false
    }
}

