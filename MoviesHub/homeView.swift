//
//  homeView.swift
//  MoviesHub
//
//  Created by iMac02 on 21/02/26.
//
import SwiftUI

struct homePagemovieView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Rectangle()
                    .foregroundStyle(Color.black)
                    .frame(height: 60)
                    
                ScrollView(.vertical){
                    VStack {
                        interFace()
                        promotionalView()
                        movieFeed()
                    }
                }
                HomeBottomView()
            }
            .ignoresSafeArea()
            .background(Color.black)
        }
        .toolbar(.hidden)
    }
}

#Preview {
    homePagemovieView()
}
struct promotionalView: View {
    var count = [
        GridItem(.flexible(minimum: 50, maximum: 250))
    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .top){
                LazyHGrid(rows: count){
                    ForEach(MovieD.sorted(by: <), id: \.key){key, value in
                        ZStack(alignment: .leading){
                            Image("\(key)")
                                .resizable()
                                .cornerRadius(10)
                                .frame(minHeight: 100)
                                .frame(maxHeight: 400)
                                .clipped()
                                .aspectRatio(1.6/1.1, contentMode: .fit)
                            VStack(alignment: .leading){
                                NavigationLink{
                                    movieIteam(currentMovie: "\(key)", currentCategory: "\(value)")
                                }label:{
                                    HStack(alignment: .center){
                                        Image(systemName: "play.square.fill")
                                            .resizable()
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .frame(width: 40, height: 30)
                                            .cornerRadius(6)
                                        Text("Play")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: 18))
                                            .bold()
                                        Spacer()
                                    }
                                }
                               
                                Spacer()
                            }
                            .padding()
                        }
                        .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1))
                    }
                }
            }
        }
        .padding(EdgeInsets(top: -70, leading: 1, bottom: -70, trailing: 0))
    }
}

struct movieFeed: View {
    var count = [
        GridItem(.flexible(minimum: 50, maximum: 250))
    ]
    var body: some View {
        VStack(alignment: .leading){
            ForEach(movieCategory, id: \.self){i in
                Text("\(i)")
                    .font(.system(size: 22))
                    .bold()
                    .padding(.leading)
                    .foregroundStyle(Color.white)
                ScrollView(.horizontal, showsIndicators: false){
                            LazyHGrid(rows: count){
                                ForEach(MovieD.sorted(by: <), id: \.key){key, value in
                                    NavigationLink{
                                        movieIteam(currentMovie: "\(key)", currentCategory: "\(value)")
                                    }label: {
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
                                            .aspectRatio(0.6/0.9, contentMode: .fit)
                                    }
                                    
                                }
                            }
                }
                .padding(EdgeInsets(top: -70, leading: 10, bottom: -70, trailing: 5))
            }
        }
            
        }
}
    

struct HomeBottomView: View {
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Spacer()
                    VStack(alignment: .center){
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 30, height: 25)
                        Text("Home")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.red)
                    
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
                    NavigationLink{
                        ProfileView()
                    }label: {
                        VStack(alignment: .center){
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Profile")
                                .font(.caption)
                        }
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
