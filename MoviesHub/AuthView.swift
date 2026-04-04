//
//  AuthView.swift
//  MoviesHub
//
//  Created by iMac02 on 21/02/26.
//
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

final class AuthViewModel: ObservableObject {
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    @Published var isauthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private lazy var auth: Auth = {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return Auth.auth()
    }()
    
    private var db: Firestore {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return Firestore.firestore()
    }
    
    func login(username: String, password: String) {
        errorMessage = nil
        isLoading = true
        let email = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !trimmedPassword.isEmpty else {
            self.errorMessage = "Please fill all fields."
            self.isLoading = false
            return
        }

        auth.signIn(withEmail: email, password: trimmedPassword) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.isauthenticated = false
                }
                return
            }

            guard let uid = result?.user.uid else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Unable to retrieve user information."
                    self.isauthenticated = false
                }
                return
            }

            // Verify user document exists in Firestore before proceeding
            self.db.collection("users").document(uid).getDocument { snapshot, err in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let err = err {
                        self.errorMessage = err.localizedDescription
                        self.isauthenticated = false
                        return
                    }

                    guard let snapshot = snapshot, snapshot.exists else {
                        self.errorMessage = "Account not found in database."
                        self.isauthenticated = false
                        return
                    }

                    // Success: credentials valid and user document exists
                    self.errorMessage = nil
                    self.isauthenticated = true
                }
            }
        }
    }
    
    
    func signup (name: String, username: String, password: String) {
        errorMessage = nil
        isLoading = true

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !email.isEmpty, !trimmedPassword.isEmpty else {
            self.errorMessage = "Please fill all fields."
            self.isLoading = false
            return
        }

        auth.createUser(withEmail: email, password: trimmedPassword) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let uid = result?.user.uid else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Unable to retrieve user information."
                }
                return
            }

            let userData: [String: Any] = [
                "uid": uid,
                "name": trimmedName,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ]

            self.db.collection("users").document(uid).setData(userData) { [weak self] err in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let err = err {
                        self.errorMessage = err.localizedDescription
                        self.isauthenticated = false
                    } else {
                        self.errorMessage = nil
//                        withAnimation {
                            self.isauthenticated = true
//                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            isauthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct AuthView: View {
    @ObservedObject var auth: AuthViewModel
    @State private var selection : Int = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(colors: [.black,.red.opacity(0.8),.black], startPoint: .top, endPoint: .bottom)
                VStack(alignment: .center,spacing: 30){
                    Image("logo")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 30)
                        .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                    Picker("pick an option", selection: $selection){
                        Text("Log In").tag(0)
                        Text("Sign Up").tag(1)
                        
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(EdgeInsets(top: -40, leading: 0, bottom: 0, trailing: 0))

                    if selection == 0{
                        LogInView(auth: auth, selection: $selection)
                    }
                    else{
                        SignUpView(auth: auth)
                        
                    }

                    if let error = auth.errorMessage{
                        Text(error)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .toolbar(.hidden)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $auth.isauthenticated) {
                HomeView(auth: auth)
            }
        }
    }
   
}
#Preview() {
    AuthView(auth: AuthViewModel())
        .environmentObject(BookmarkStore())
}

struct LogInView: View {
    @ObservedObject var auth: AuthViewModel
    @Binding var selection: Int
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
                Button(action: {
                    selection = 1
                }) {
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

struct SignUpView: View {
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
                auth.signup(name: name, username: username, password: password)
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

struct HomeView: View {
    @ObservedObject var auth: AuthViewModel
    var body: some View {
        homePagemovieView()
        }
    }

