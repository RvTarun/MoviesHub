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
    @State private var didAttemptChange: Bool = false
    
   var body: some View {
       NavigationStack{
           ZStack{
               LinearGradient(colors: [.black,.red.opacity(0.8),.black], startPoint: .top, endPoint: .bottom)
               VStack(alignment: .center, spacing: 15){
                   VStack{
                       Image("logo")
                           .resizable()
                           .frame(width: 250, height: 250)
                           .shadow(radius: 30)
                           .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                       Text("Change Password")
                           .bold()
                           .font(Font.largeTitle)
                   }
                   VStack(spacing: 15){
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
                   }
                   Spacer()
                   if let error = auth.errorMessage {
                       Text(error)
                           .foregroundColor(.red)
                           .padding(.bottom, 4)
                   } else if didAttemptChange && !auth.isLoading && auth.errorMessage == nil {
                       Text("Password updated successfully.")
                           .foregroundColor(.green)
                           .padding(.bottom, 4)
                   }
                  
                  Button(action: {
                      didAttemptChange = true
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
