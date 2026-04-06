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
    @StateObject private var auth = AuthViewModel()
    @State private var oldpass: String = ""
    @State private var newpass: String = ""
    @State private var confirmpass: String = ""
    
   var body: some View {
       NavigationStack{
           ZStack{
               LinearGradient(colors: [.black,.red.opacity(0.8),.black], startPoint: .top, endPoint: .bottom)
               VStack(alignment: .center, spacing: 15){
                   Spacer()
                   Image("logo")
                       .resizable()
                       .frame(width: 300, height: 300)
                       .shadow(radius: 30)
                       .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                   SecureField("Enter Old Password", text: $oldpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   SecureField("Enter New Password", text: $newpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   SecureField("Confirm Password", text: $confirmpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   Spacer()
                  Button(action: {
                      auth.changePassword(oldPassword: oldpass, newPassword: newpass, confirmPassword: confirmpass)
                  }) {
                      if auth.isLoading {
                          ProgressView()
                              .tint(.white)
                              .frame(maxWidth: .infinity)
                              .padding()
                      } else {
                          Text("Submit")
                              .frame(maxWidth: .infinity)
                              .font(.system(size: 20))
                              .bold()
                              .foregroundColor(.white)
                              .padding()
                      }
                  }
                  .background(Color.black)
                  .clipShape(RoundedRectangle(cornerRadius: 50))
                  .disabled(auth.isLoading)
                  
                  if let error = auth.errorMessage {
                      Text(error)
                          .foregroundColor(.red)
                  } else if !auth.isLoading && !oldpass.isEmpty && !newpass.isEmpty && !confirmpass.isEmpty {
                      Text("Password updated successfully.")
                          .foregroundColor(.green)
                  }
                   Spacer()
               }
               .padding(.horizontal)
           }
           .ignoresSafeArea()
          
       }
    }
    
}

#Preview {
    forgetPassView()
}
