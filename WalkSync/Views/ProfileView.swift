import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                
            }
            .padding()

            // Profile Picture and User Info
            VStack(spacing: 10) {
                Image(systemName: "person.crop.circle.fill") // Replace with actual profile image if available
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Text("Joseph Madagascar")
                    .font(.title2)
                    .bold()
                Text("mjoseph@gmail.com")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()

            // Goal Weight
            VStack {
                Text("75 kg")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text("Goal Weight")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.orange)
            .cornerRadius(10)
            .padding(.horizontal)

            // Details Section
            VStack(spacing: 20) {
                VStack {
                    Text("320 cal/day")
                        .font(.title3)
                        .bold()
                    Text("Calories Per Day")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)

                HStack(spacing: 20) {
                    VStack {
                        Text("82 kg")
                            .font(.title3)
                            .bold()
                        Text("Current Weight")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)

                    VStack {
                        Text("172 cm")
                            .font(.title3)
                            .bold()
                        Text("Current Height")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Profile")
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
