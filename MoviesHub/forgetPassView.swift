//
//  forgetPassView.swift
//  MoviesHub
//
//  Created by iMac02 on 21/02/26.
//

import SwiftUI
import Combine
import FirebaseAuth

struct forgetPassView: View {
    // Local state
    @State private var email: String = ""
    @State private var newpass: String = ""
    @State private var confirmpass: String = ""

    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil

    // Flow control: first verify email, then allow password change
    @State private var emailVerified: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, .red.opacity(0.8), .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .center, spacing: 15) {
                    VStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .shadow(radius: 30)
                            .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                        Text("Forgot Password")
                            .bold()
                            .font(.largeTitle)
                    }

                    VStack(spacing: 15) {
                        TextField("Enter Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .shadow(radius: 10)
                            .disabled(emailVerified || isLoading)

                        if emailVerified {
                            SecureField("Enter New Password", text: $newpass)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .shadow(radius: 10)

                            SecureField("Confirm Password", text: $confirmpass)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .shadow(radius: 10)
                        }
                    }

                    Spacer()

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.bottom, 4)
                    } else if let success = successMessage {
                        Text(success)
                            .foregroundColor(.green)
                            .padding(.bottom, 4)
                    }

                    Button(action: primaryAction) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text(emailVerified ? "Update Password" : "Verify Email")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .disabled(isLoading)

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Actions

    private func primaryAction() {
        errorMessage = nil
        successMessage = nil
        if emailVerified {
            updatePasswordFlow()
        } else {
            verifyEmailExistsFlow()
        }
    }

    private func verifyEmailExistsFlow() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email."
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        // Try login with dummy password to check email existence
        Auth.auth().signIn(withEmail: email, password: "dummyPassword123") { result, error in
            
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error as NSError? {
                    
                    let code = AuthErrorCode(_bridgedNSError: error)

                    switch code {
                    case .wrongPassword:
                        // ✅ Email exists (password wrong but email correct)
                        self.emailVerified = true
                        self.successMessage = "Email found ✅ Enter new password"

                    case .userNotFound:
                        // ❌ Email does not exist
                        self.errorMessage = "Email not found"

                    case .invalidEmail:
                        self.errorMessage = "Invalid email format"

                    default:
                        self.errorMessage = error.localizedDescription
                    }
                } else {
                    // Rare case: login success (means password matched dummy 😅)
                    self.emailVerified = true
                    self.successMessage = "Email verified"
                }
            }
        }
    }

    private func updatePasswordFlow() {
        guard !newpass.isEmpty, !confirmpass.isEmpty else {
            errorMessage = "Please fill in both password fields."
            return
        }
        guard newpass == confirmpass else {
            errorMessage = "Passwords do not match."
            return
        }
        guard newpass.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoading = true

        // If the user is already signed in and owns this email, we can update directly.
        if let user = Auth.auth().currentUser, user.email?.lowercased() == email.lowercased() {
            user.updatePassword(to: newpass) { error in
                isLoading = false
                if let error = error {
                    errorMessage = friendlyError(error)
                } else {
                    successMessage = "Password updated successfully. You can now log in with your new password."
                }
            }
            return
        }

        // Otherwise, send password reset email (secure flow).
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            isLoading = false
            if let error = error {
                errorMessage = friendlyError(error)
            } else {
                successMessage = "A password reset email has been sent. Please follow the instructions to set a new password."
            }
        }
    }

    // MARK: - Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    private func friendlyError(_ error: Error) -> String {
        let ns = error as NSError
        switch AuthErrorCode(_bridgedNSError: ns)?.code {
        case .userNotFound:
            return "Email not found."
        case .invalidEmail:
            return "Invalid email address."
        case .weakPassword:
            return "Password is too weak."
        case .requiresRecentLogin:
            return "For security, please sign in again to change your password."
        default:
            return ns.localizedDescription
        }
    }
}

#Preview {
    forgetPassView()
}
