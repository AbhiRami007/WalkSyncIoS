import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("onboarding_background") // Replace with your asset name
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Overlay content
                VStack {
                    Spacer()
                    
                    // Welcome Text
                    VStack(spacing: 10) {
                        Text("Welcome to Walk Sync")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Your ultimate companion for tracking steps, speed, and direction.")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        // NavigationLink for "Get Started"
                        NavigationLink(destination: SignupView()) {
                            HStack {
                                Image(systemName: "figure.walk.circle.fill") // Add icon
                                    .foregroundColor(.white)
                                Text("Get Started")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .padding(.horizontal, 50)
                        }
                        
//                         NavigationLink for "Login"
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.orange)
                                .cornerRadius(25)
                                .padding(.horizontal, 50)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
