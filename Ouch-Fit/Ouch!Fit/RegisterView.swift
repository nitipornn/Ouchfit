import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dob: Date = Date() // Using Date for DOB
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            // Username TextField
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 20)

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 20)

            // Phone TextField
            TextField("Phone", text: $phone)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 20)

            // Date of Birth Picker
            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
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

            // Password strength recommendation
            Text(passwordStrengthMessage())
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }

            // Register Button
            Button(action: {
                registerUser()
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }

    func registerUser() {
        // Clear previous errors
        errorMessage = ""

        // Validate the input fields
        if username.isEmpty || password.isEmpty || email.isEmpty || phone.isEmpty {
            errorMessage = "All fields are required!"
            return
        }

        if !isValidPassword(password) {
            errorMessage = "Password must be at least 8 characters long, include uppercase, lowercase, a number, and a special character!"
            return
        }

        // Save user data to Firebase Realtime Database
        let dbRef = Database.database().reference().child("User").child(username)
        
        let userData = [
            "username": username,
            "password": password,
            "email": email,
            "phone": phone,
            "dob": dob.description
        ]
        
        dbRef.setValue(userData) { error, _ in
            if let error = error {
                errorMessage = "Registration failed: \(error.localizedDescription)"
            } else {
                dismiss() // Close registration page after successful registration
            }
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        // Password must be at least 8 characters long and contain a mix of upper case, lower case, digits, and special characters.
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    func passwordStrengthMessage() -> String {
        if password.isEmpty {
            return "Password should be at least 8 characters long."
        }
        if !isValidPassword(password) {
            return "Password needs to contain uppercase, lowercase, digits, and a special character."
        }
        return "Password strength is good."
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
