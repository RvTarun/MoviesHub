//
//  forgetPassView.swift
//  MoviesHub
//
//  Created by iMac02 on 21/02/26.
//

import SwiftUI
import Combine

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
                   TextField("Enter Old Password", text: $oldpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   TextField("Enter New Password", text: $newpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   TextField("Confirm Password", text: $confirmpass)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .textInputAutocapitalization(.never)
                       .shadow(radius: 10)
                   Spacer()
                  NavigationLink(destination: AuthView(auth: auth)){
                      Text("Submit")
                          .frame(maxWidth: .infinity)
                          .font(.system(size: 20))
                          .bold()
                          .foregroundColor(.white)
                          .padding()
                          .background(Color.black)
                          .clipShape(RoundedRectangle(cornerRadius: 50))
                       
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
