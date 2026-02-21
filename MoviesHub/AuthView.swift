//
//  AuthView.swift
//  MoviesHub
//
//  Created by iMac02 on 21/02/26.
//
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isauthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var users: [String: String] = [:]
    
    
    func login(username: String, password: String) {
        errorMessage = nil
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if username.isEmpty || password.isEmpty {
                self.errorMessage = "Please fill all fields."
                return
            }
            
            guard let savepassword = self.users[username] else{
                self.errorMessage = "Invalid username or password."
                return
            }
            guard savepassword == password else{
                self.errorMessage = "Password is incorrect."
                return
            }
            self.errorMessage = nil
            self.isauthenticated = true
        }
    }
    
    
    func singup (name: String, username: String, password: String) {
        errorMessage = nil
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if name.isEmpty || username.isEmpty || password.isEmpty {
                self.errorMessage = "Please fill all fields."
                return
            }
            self.users[username] = password
            self.errorMessage = nil
            self.isauthenticated = true
        }
    }
    
    func logout() {
        isauthenticated = false
    }
}

struct AuthView: View {
    @ObservedObject var auth: AuthViewModel
    @State private var selection : Int = 0
    
    var body: some View {
        VStack(spacing: 15){
//            Spacer()
            Text("Movies Hub")
                .font(.largeTitle)
            Picker("pick an option", selection: $selection){
                Text("Login").tag(0)
                Text("Sign Up").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if selection == 0{
                LogInView(auth: auth)
            }
            else{
                SingUpView(auth: auth)
            }
            
            if let error = auth.errorMessage{
                Text(error)
                    .foregroundColor(.red)
//                    .padding()
            }
                
        }
        .toolbar(.hidden)
    }
   
}
#Preview() {
    AuthView(auth: AuthViewModel())
}

struct LogInView: View {
    @ObservedObject var auth: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .center){
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                auth.login(username: username, password: password)
            }){
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    
            }
            .disabled(auth.isLoading)
            .padding(.vertical)

        }
        .padding(.horizontal)
    }
    
}

struct SingUpView: View {
    @ObservedObject var auth: AuthViewModel
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .center){
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                auth.singup(name: name, username: username, password: password)
            }){
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                
            }
            .disabled(auth.isLoading)
            .padding(.vertical)

        }
        .padding(.horizontal)
    }
    
}

