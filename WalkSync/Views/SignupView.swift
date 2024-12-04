//
//  SignupView.swift
//  WalkSync
//
//  Created by Abhirami Pradeep Susi on 2024-12-03.
//

import SwiftUI

struct SignupView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var calorieIntake = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    private let databaseHelper = DatabaseHelper()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Get Started")
                    .font(.largeTitle)
                    .bold()
                
                Text("Fill up the registration to get started with your fitness journey.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Group {
                    TextField("Full Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                    
                    TextField("Daily Calorie Intake", text: $calorieIntake)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("Current Weight", text: $weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Current Height", text: $height)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Button("Cancel") {
                        clearFields()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Button("Register Now") {
                        registerUser()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")
        }
    }
    
    private func clearFields() {
        name = ""
        email = ""
        calorieIntake = ""
        weight = ""
        height = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
    }
    
    private func registerUser() {
        errorMessage = ""
        
        if name.isEmpty || email.isEmpty || calorieIntake.isEmpty || weight.isEmpty || height.isEmpty || password.isEmpty {
            errorMessage = "All fields are required!"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match!"
            return
        }
        
        if databaseHelper.checkEmailExists(email: email) {
            errorMessage = "Email already registered!"
            return
        }
        
        let isInserted = databaseHelper.insertUser(name: name, email: email, calorieIntake: calorieIntake, weight: weight, height: height, password: password)
        if isInserted {
            clearFields()
            errorMessage = "Registration successful!"
        } else {
            errorMessage = "Registration failed!"
        }
    }
}
