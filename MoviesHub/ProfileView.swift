//
//  ProfileView.swift
//  MoviesHub
//
//  Created by iMac02 on 12/02/26.
//
import SwiftUI
struct ProfileView: View {
    @ObservedObject var auth = AuthViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                interFace()
                ProfileContent()
                ProfileViewBottom()
            }
            .background(Color(.black))
        }
        .toolbar(.hidden)
    }
}
#Preview {
    ProfileView()
}

struct ProfileContent: View {
    @ObservedObject var auth = AuthViewModel()
    var count = [
        GridItem(.flexible(minimum: 50, maximum: 250))
    ]
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(5)
                    VStack(alignment: .leading){
                        Text("\(userName[0])")
                            .font(.system(size: 22, weight: .bold, design: .default))
                        Text("\(userName[0])@stream.com")
                            .font(.system(size: 14, weight: .regular))
                            .opacity(0.8)
                    }
                    Spacer()
                    Text("Edit")
                        .font(.system(size: 14, weight: .bold))
                        .padding(10)
                        .foregroundStyle(Color(.blue))
                        .opacity(0.7)
                }
                .foregroundStyle(Color(.white))
                
                Text("Watchlist")
                    .foregroundStyle(Color(.white))
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .padding(10)
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHGrid(rows: count){
                        ForEach(imgName, id: \.self){i in
                            Image(imgName[Int.random(in: 0..<14)])
                                .resizable()
                                .cornerRadius(10)
                                .frame(minHeight: 100)
                                .frame(maxHeight: 400)
                                .clipped()
                                .overlay(
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                        .frame(width: 50, height: 50)
                                )
                                .aspectRatio(1/1.8, contentMode: .fit)
                        }
                    }
                }
                .padding(EdgeInsets(top: -80, leading: 1, bottom: -80, trailing: 1))
                Text("Continue Watching")
                    .foregroundStyle(Color(.white))
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .padding(10)
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHGrid(rows: count){
                        ForEach(imgName, id: \.self){i in
                            Image(imgName[Int.random(in: 0..<14)])
                                .resizable()
                                .cornerRadius(10)
                                .frame(minHeight: 100)
                                .frame(maxHeight: 400)
                                .clipped()
                                .overlay(
                                    Image(systemName: "play.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                        .frame(width: 50, height: 50)
                                )
                                .aspectRatio(1/1.8, contentMode: .fit)
                        }
                    }
                }
                .padding(EdgeInsets(top: -80, leading: 1, bottom: -80, trailing: 1))
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundStyle(Color(.red))
                        .opacity(0.4)
                    HStack{
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(.white))
                            .padding(5)
                        Text("Manage Watchlist")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .foregroundStyle(Color.white)
                    
                }
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing:10))
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundStyle(Color(.red))
                        .opacity(0.4)
                    HStack{
                        Image(systemName: "clock.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(.white))
                            .padding(5)
                        Text("Viewing History")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .foregroundStyle(Color.white)
                    
                }
                .padding(EdgeInsets(top: -10, leading: 10, bottom: 0, trailing:10))
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundStyle(Color(.red))
                        .opacity(0.4)
                    HStack{
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(.white))
                            .padding(5)
                        Text("Change Email")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .foregroundStyle(Color.white)
                    
                }
                .padding(EdgeInsets(top: -10, leading: 10, bottom: 0, trailing:10))
                
                Button(action: {
                    auth.logout()
                }){
                    NavigationLink{
                        ContentView()
                    } label: {
                        Text("log Out \(Image(systemName: "rectangle.portrait.and.arrow.right"))")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }  
                }
                .disabled(auth.isLoading)
                
            }
        }
        
    }
}


struct ProfileViewBottom: View {
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Spacer()
                    NavigationLink{
                        homePagemovieView()
                    }label: {
                        VStack(alignment: .center){
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 30, height: 25)
                            Text("Home")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    NavigationLink{
                        WatchList()
                    }label: {
                        VStack(alignment: .center){
                            Image(systemName: "play.rectangle.on.rectangle")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Watchlist")
                                .font(.caption)
                        }
                    }
                   
                    Spacer()
                        VStack(alignment: .center){
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Profile")
                                .font(.caption)
                        }
                    Spacer()
                }
                .foregroundStyle(Color(.white))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .offset(y: -32)
                )
            }
            .frame(height: 50)
        }
    }
    
}
