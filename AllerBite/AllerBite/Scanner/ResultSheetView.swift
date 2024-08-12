import SwiftUI
import GoogleGenerativeAI
import Vision

struct ResultSheetView: View {
    @State private var navigateToContentView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var capturedImage: UIImage?
    @Binding var responseText: String
    @State private var chatMessages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var extractedText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 15) {
                        if let image = capturedImage ?? readImage() {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .padding(.top)
                                .onAppear {
                                    extractText(from: image)
                                }
                        }

                        VStack {
                            Image(systemName: "x.circle")
                                .foregroundColor(.red)
                                .font(.system(size: 50))
                                .cornerRadius(100)
                            
                            Text("This product is not safe for you.")
                                .font(.title3)
                                .foregroundColor(.red)
                                .lineSpacing(5)
                                .offset(y: 20)
                        }

                        Text("Response from Gemini:")
                            .font(.headline)
                            .padding(.top)

                        Text(responseText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)

                        ForEach(chatMessages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }

                HStack {
                    TextField("Type your message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)

                    Button(action: {
                        sendMessage()
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Result")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigateToContentView = true
                    }) {
                        Text("Done")
                            .foregroundColor(.green)
                    }
                }
            }
            .fullScreenCover(isPresented: $navigateToContentView) {
                ContentView().navigationBarBackButtonHidden(true)
            }
        }
    }

    func sendMessage() {
        // Add user's message to chat
        let userMessage = ChatMessage(text: userInput, isUser: true)
        chatMessages.append(userMessage)

        // Clear the input field
        userInput = ""
        
        if let image = capturedImage ?? readImage() {
            analyze(uiImage: image)
        }


        // Generate response using Gemini
        Task {
            do {
                let generationConfig = GenerationConfig(
                    temperature: 0,
                    topP: 0.95,
                    topK: 64,
                    maxOutputTokens: 8192
                )

                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default,
                    generationConfig: generationConfig
                )

                // Convert chat history to an array of ModelContent objects
                let chatHistory: [ModelContent] = try chatMessages.map { message in
                    try ModelContent(message.text)
                }

                let chatSession = model.startChat(history: chatHistory)
                let response = try await chatSession.sendMessage([ModelContent(userMessage.text)])

                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
                chatMessages.append(responseMessage)
            } catch let error as GenerateContentError {
                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            } catch {
                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            }
        }
    }

    @MainActor func analyze(uiImage: UIImage) {
//           let prompt = """
//           From the given image, you need to run the following tasks:
//           1. Identify the ingredient name
//           2. Suggest one popular meal name from the given image
//           3. List other ingredients from the meal name
//           4. Return the recipes containing other ingredients and steps on how to cook the meal
//           5. If the image is not an ingredient, just say I don't know
//           6. Consider the following allergies: nut, gluten, dairy
//           """

           Task {
               do {
                   let model = GenerativeModel(
                       name: "gemini-1.5-flash",
                       apiKey: APIKey.default,
                       generationConfig: GenerationConfig(
                           temperature: 0.7,
                           topP: 0.95,
                           topK: 64,
                           maxOutputTokens: 8192
                       )
                   )

                   let response = try await model.generateContent(uiImage)

                   if let text = response.text {
                       print("Response: \(text)")
                       let responseMessage = ChatMessage(text: text, isUser: false)
                       chatMessages.append(responseMessage)
                   }
               } catch {
                   print(error.localizedDescription)
               }
           }
       }

    
    func readImage() -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
        
        if let imageData = try? Data(contentsOf: imageUrl) {
            return UIImage(data: imageData)
        } else {
            print("Image file not found.")
            return nil
        }
    }

    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            self.extractedText = recognizedStrings.joined(separator: "\n")
            self.responseText = self.extractedText // Update responseText with extracted text

            // Send the extracted text to Gemini for more information
            sendExtractedTextToGemini()
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error.localizedDescription)")
        }
    }

    func sendExtractedTextToGemini() {
        // Generate response using Gemini
        Task {
            do {
                let generationConfig = GenerationConfig(
                    temperature: 0,
                    topP: 0.95,
                    topK: 64,
                    maxOutputTokens: 8192
                )

                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default,
                    generationConfig: generationConfig
                )

                // Craft a detailed prompt
                let prompt = """
                Based on the following ingredients: \(extractedText), please provide:
                1. A list of allergenic ingredients.
                2. Alternative products that are safe for someone with these allergies.
                3. A summary of any harmful ingredients found.
                """

                let chatSession = model.startChat(history: [])
                let response = try await chatSession.sendMessage([ModelContent(prompt)])

                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
                chatMessages.append(responseMessage)
            } catch let error as GenerateContentError {
                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            } catch {
                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            }
        }
    }
}

struct ChatBubble: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
        .padding(message.isUser ? .leading : .trailing, 40)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

