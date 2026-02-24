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
        NavigationStack{
            ScrollView{
                VStack(alignment: .center){
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
                        NavigationLink{
                            ProfileEditView()
                        } label: {
                            Text("Edit")
                                .font(.system(size: 14, weight: .bold))
                                .padding(10)
                                .foregroundStyle(Color(.blue))
                                .opacity(0.7)
                        }
                        
                    }
                    .foregroundStyle(Color(.white))
//---------------------------------Continue Watching Section---------------------------\\
                    VStack(alignment: .leading){
                        Text("Continue Watching")
                            .foregroundStyle(Color(.white))
                            .font(.system(size: 22, weight: .bold, design: .default))
                            .padding(10)
                        
                        // ContinueWatching
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHGrid(rows: count){
                                ForEach(Array(MovieD).shuffled(), id: \.key){key , value in
                                    ZStack{
                                        Image("\(key)")
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
                                        
                                        ProgressView(value: 40.7, total: 100)
                                            .tint(Color(.red))
                                            .padding(EdgeInsets(top: 0, leading: 2, bottom: -10, trailing: 2))
                                            .offset(y: 120)
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: -80, leading: 1, bottom: -70, trailing: 1))
                        
                    }
//---------------------------------WatchList Section---------------------------\\
                    VStack(alignment: .leading){
                        Text("Watchlist")
                            .foregroundStyle(Color(.white))
                            .font(.system(size: 22, weight: .bold, design: .default))
                            .padding(10)
                        
                        // watchList
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHGrid(rows: count){
                                ForEach(Array(MovieD).shuffled(), id: \.key){key, value in
                                    Image("\(key)")
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
                        .padding(EdgeInsets(top: -80, leading: 1, bottom: -60, trailing: 1))
                        
                    }
                   
//-----------------------------------Bookmark Button------------------------------------------------\\
                    NavigationLink{
                       BookmarkView()
                    } label: {
                        Text("\(Image(systemName: "bookmark.fill")) Manage Watchlist")
                            
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    
//-----------------------------------History Button------------------------------------------------\\

                    NavigationLink{
                       HistoryView()
                    } label: {
                        Text("\(Image(systemName: "clock.fill")) History")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
//-----------------------------------Change Email Button------------------------------------------------\\

                    NavigationLink{
                       ChangeEmailView()
                    } label: {
                        Text("\(Image(systemName: "envelope.fill")) Change Email")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
//-----------------------------------Bookmark Button------------------------------------------------\\

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
                    Spacer()
                    VStack(spacing: 1){
                        Text("MoviesHub")
                        Text("Version 1.0")
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.gray))
                    Spacer()
                    
                }
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
                        .foregroundStyle(Color.red)
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

