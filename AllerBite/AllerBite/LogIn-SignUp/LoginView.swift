import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToScreenView = false
    @State private var userName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login here")
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .font(.system(size: 34))
                    .bold()
                
                Text("Welcome back you’ve")
                    .font(.title)
                    .padding(.top)
                
                Text("been missed!")
                    .font(.title)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("Forgot your password?")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .offset(x:100)
                
                NavigationLink(destination: ScreenView(userName: userName), isActive: $navigateToScreenView) {
                    Button(action: {
                        loginUser()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 12, leading: 75, bottom: 12, trailing: 75))
                            .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                            .cornerRadius(10)
                    }
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    .disabled(email.isEmpty || password.isEmpty)
                }
                
                NavigationLink(destination: RegisterView()) {
                    Text("Create new Account")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 30, trailing: 0))
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "g.circle")
                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(100)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
                    
                    Button(action: {
                        print("Apple Sign-In not yet implemented")
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(100)
                    }
                    .disabled(true) // Disable button as functionality isn't ready
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Firebase login function
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                // Navigate to the main screen
                if let user = authResult?.user {
                    userName = user.displayName ?? "User"
                }
                navigateToScreenView = true
            }
        }
    }

    // Google Sign-In function
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { user, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            guard let user = user?.user else {
                return
            }
            
            let idToken = user.idToken!.tokenString
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }
                
                guard let user = res?.user else { return }
                userName = user.displayName ?? "User"
                navigateToScreenView = true
            }
        }
    }
    
    // Helper function to get the root view controller
    func getRootViewController() -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
}

#Preview {
    LoginView()
}
