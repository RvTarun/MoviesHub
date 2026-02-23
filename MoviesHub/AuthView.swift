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
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.black,.red.opacity(0.8),.black], startPoint: .top, endPoint: .bottom)
                VStack(alignment: .center,spacing: 30){
    //                    Spacer()
                        Image("logo")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .shadow(radius: 30)
                            .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                        Picker("pick an option", selection: $selection){
                            Text("Sign Up").tag(0)
                            Text("Log In").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(EdgeInsets(top: -40, leading: 0, bottom: 0, trailing: 0))
                        
                        if selection == 0{
                            SingUpView(auth: auth)
                        }
                        else{
                            LogInView(auth: auth)
                        }
                        
                        if let error = auth.errorMessage{
                            Text(error)
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .toolbar(.hidden)
            }.ignoresSafeArea()
           
        }
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
        VStack(alignment: .center,spacing: 15){
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .shadow(radius: 10)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(radius: 10)
            
            HStack{
                NavigationLink{
                AuthView(auth: auth)
                } label: {
                    Text("New User")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.green.opacity(0.8))
                }
                Spacer()
                NavigationLink{
                    forgetPassView()
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.green.opacity(0.8))
                }
                
            }
            
            Button(action: {
                auth.login(username: username, password: password)
            }){
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
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
        VStack(alignment: .center, spacing: 15){
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(radius: 10)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .shadow(radius: 10)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(radius: 10)
            
            Button(action: {
                auth.singup(name: name, username: username, password: password)
            }){
                Text("Sign Up")
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                
            }
            .disabled(auth.isLoading)
            .padding(.vertical)

        }
        .padding(.horizontal)
    }
    
}

