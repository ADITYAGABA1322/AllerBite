//
//  MealImageToRecipeView.swift
//  AllerBite
//
//  Created by Aditya Gaba on 8/12/24.
//
import SwiftUI
import PhotosUI
import GoogleGenerativeAI
import UIKit

struct MealImageToRecipeView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var analyzedResult: String?
    @State private var isAnalyzing: Bool = false
    @State private var isShowingCamera = false
    @State private var allergies: [String] = []
    @State private var showResultView = false
    
    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]

    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    var body: some View {
        NavigationView{
            VStack {
                Text("🍕 Meal Image to Recipe")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Powered by Gemini AI :")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Text("Upload an image of a meal to get a recipe on how to cook it.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .overlay {
                            if isAnalyzing {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(Color.black.opacity(0.5))
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .padding(.horizontal)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.horizontal)
                }
                
                ScrollView {
                    Text(analyzedResult ?? (isAnalyzing ? "Analyzing..." : "Select or capture a photo to get started"))
                        .font(.system(.title2, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.horizontal)
                }
                
                Spacer()
                
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    }
                    
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Label("Capture Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera) { image in
                            if let image = image {
                                selectedImage = Image(uiImage: image)
                                analyze(uiImage: image)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Select Allergies")
                        .font(.headline)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(allergyOptions, id: \.self) { allergy in
                                Button(action: {
                                    if allergies.contains(allergy) {
                                        allergies.removeAll { $0 == allergy }
                                    } else {
                                        allergies.append(allergy)
                                    }
                                }) {
                                    Text(allergy)
                                        .padding()
                                        .background(allergies.contains(allergy) ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .onChange(of: selectedItem) { oldItem, newItem in
                Task {
                    if let image = try? await newItem?.loadTransferable(type: Image.self) {
                        selectedImage = image
                        if let uiImage = image.asUIImage() {
                            analyze(uiImage: uiImage)
                        }
                    }
                }
            }
            .sheet(isPresented: $showResultView) {
                if let result = analyzedResult, let image = selectedImage {
                    ResultView(result: result, image: image)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    

    @MainActor func analyze(uiImage: UIImage) {
        self.analyzedResult = nil
        self.isAnalyzing.toggle()

        let prompt = """
        From the given image, you need to run the following tasks:
        1. Identify the ingredient name
        2. Suggest one popular meal name from the given image
        3. List other ingredients from the meal name
        4. Return the recipes containing other ingredients and steps on how to cook the meal
        5. If the image is not an ingredient, just say I don't know
        6. Consider the following allergies: \(allergies.joined(separator: ", "))
        """

        Task {
            do {
                let response = try await model.generateContent(prompt, uiImage)

                if let text = response.text {
                    print("Response: \(text)")
                    self.analyzedResult = text
                    self.isAnalyzing.toggle()
                    self.showResultView = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ResultView: View {
    let result: String
    let image: Image

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()

            ScrollView {
                Text(result)
                    .padding()
            }
            .navigationTitle("Generated Recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var completion: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            parent.completion(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.completion(nil)
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

#Preview{
    MealImageToRecipeView()
}
