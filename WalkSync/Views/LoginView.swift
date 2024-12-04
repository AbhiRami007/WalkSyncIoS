import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    @StateObject private var databaseHelper = DatabaseHelper() // Database Helper Instance

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // App Title
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)

                // Email Input Field
                TextField("Enter your email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Password Input Field
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Login Button
                Button(action: {
                    handleLogin()
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                // Error Message Display
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                // Register Link
                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Register here")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                MainView() // Redirect to MainView on successful login
            }
        }
    }

    // MARK: - Login Handling Logic
    func handleLogin() {
        // Validate input fields
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }

        // Check credentials in database
        let isValidUser = databaseHelper.validateUser(email: email, password: password)
        if isValidUser {
            isLoggedIn = true
            showError = false
            print("Login Successful!") // Navigate to MainView
        } else {
            errorMessage = "Invalid email or password"
            showError = true
        }
    }
}
