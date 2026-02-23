//
//  ChanfeEmailView.swift
//  MoviesHub
//
//  Created by iMac02 on 23/02/26.
//
import SwiftUI
import Combine
struct ChangeEmailView: View {
    @StateObject private var auth = AuthViewModel()
    @State private var oldEmail: String = ""
    @State private var newEmail: String = ""
    @State private var confirmEmail: String = ""
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
                    TextField("Enter Old Email ", text: $oldEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .shadow(radius: 10)
                    TextField("Enter New Email", text: $newEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .shadow(radius: 10)
                    TextField("Confirm Email", text: $confirmEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .shadow(radius: 10)
                    Spacer()
                   NavigationLink(destination: ProfileView()){
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
    ChangeEmailView()
}
