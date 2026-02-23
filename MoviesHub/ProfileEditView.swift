//
//  ProfileEditView.swift
//  MoviesHub
//
//  Created by iMac02 on 23/02/26.
//
import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.black)
                    .opacity(0.9)
                VStack{
                    Spacer()
                    ZStack{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(5)
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                            .offset(x: 30, y: -40)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                    HStack(spacing: 30){
                        VStack(alignment: .leading, spacing: 15){
                            Text("Name: ")
                                .font(.system(size: 20))
                            Text("User ID: ")
                                .font(.system(size: 20))
                            Text("Mobile: ")
                                .font(.system(size: 20))
                        }
                        VStack(alignment: .leading, spacing: 15){
                            Text("\(userName[0])")
                            Text("\(userName[0])@stream.com")
                            Text("+91 XXXXX-X7432")
                        }
                    }
                    .font(.system(size: 22))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
                    NavigationLink{
                        ProfileView()
                    } label: {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                }.foregroundStyle(.white)
            }.ignoresSafeArea()
            
        }
    }
}
#Preview {
    ProfileEditView()
}
////                            Text("\(userName[0])")
////                                .font(.system(size: 30, weight: .bold, design: .default))
////                                .padding(.leading)
//                        }
//                        HStack(alignment: .bottom, spacing: 20){
//                            Text("User ID: ")
//                                .font(.system(size: 20))
////                            Text("\(userName[0])@stream.com")
////                                .font(.system(size: 25, weight: .bold, design: .default))
////                                .padding(.leading)
//                        }
//                        HStack(alignment: .bottom, spacing: 20){
//                            Text("Mobile: ")
//                                .font(.system(size: 20))
                        
