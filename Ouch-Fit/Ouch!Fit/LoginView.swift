import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @Binding var isLoggedIn: Bool // Binding to control login state

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            // Username TextField
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 20)

            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }

            // Login Button
            Button(action: {
                loginUser()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    func loginUser() {
        // Clear any previous error messages
        errorMessage = ""
        
        // Step 1: Fetch the password associated with the username
        let dbRef = Database.database().reference().child("User").child(username)
        
        dbRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any], let storedPassword = value["Password"] as? String {
                
                // Step 2: Compare the entered password with the stored password
                if storedPassword == password {
                    // Password matches, log the user in
                    isLoggedIn = true
                    saveLoginDataToDatabase()
                } else {
                    // Password does not match
                    errorMessage = "Incorrect password!"
                }
            } else {
                // Username is not found in the database
                errorMessage = "Username not found!"
            }
        }
    }

    func saveLoginDataToDatabase() {
        // Reference to Firebase Realtime Database
        let dbRef = Database.database().reference().child("LoginPage")
        
        // Create login data
        let loginData = [
            "username": username,
            "loggedInAt": Date().description // Save login timestamp
        ]
        
        // Save login data to Firebase Realtime Database
        dbRef.childByAutoId().setValue(loginData) { error, _ in
            if let error = error {
                print("Failed to save login data: \(error.localizedDescription)")
            } else {
                print("Login data saved successfully!")
            }
        }
    }
}


