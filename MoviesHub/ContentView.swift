//
//  ContentView.swift
//  MoviesHub
//
//  Created by iMac02 on 10/02/26.
//

import SwiftUI
var MovieD = ["Star Wars": "Action", "Black Widow": "Thriller + Action", "Joker": "Action + Crime","Kalki": "Advanture + Drama", "South": "comedy", "Avatar": "Action + Adventure", "sutter Island": "Horror + Thriller", "24": "Action + comedy", "John Wick 2": "Action", "Golam": "Thriller", "Diesel": "Action + comedy", "RRR": "Documentary", "Lost City": "Documentary", "Oppenheimer": "Action + Crime","Madharaasi": "Drama"]

var userName = ["Tarun", "Shubham", "Deepanshu"]
var imgName: [String] = ["Star Wars", "Black Widow", "Joker","Kalki", "South", "Avatar", "sutter Island", "24", "John Wick 2", "Golam", "Diesel", "RRR", "Lost City", "Oppenheimer","Madharaasi"]
var movieCategory: [String] = ["Thriller", "Action", "Comedy", "Horror", "Documentary", "Fantasy", "Science Fiction", "Crime", "Drama"]
struct ContentView: View {
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
                bottom()
            }
            .ignoresSafeArea()
            .background(Color.black)
        }
        .toolbar(.hidden)
    }
      
}

#Preview {
    ContentView()
}

struct promotionalView: View {
    var count = [
        GridItem(.flexible(minimum: 50, maximum: 250))
    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .top){
                LazyHGrid(rows: count){
                    ForEach(imgName, id: \.self){i in
                        ZStack(alignment: .leading){
                            Image("\(i)")
                                .resizable()
                                .cornerRadius(10)
                                .frame(minHeight: 100)
                                .frame(maxHeight: 400)
                                .clipped()
                                .aspectRatio(1.6/1.1, contentMode: .fit)
                            VStack(alignment: .leading){
                                NavigationLink{
                                    movieIteam()
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
                                        .aspectRatio(0.6/0.9, contentMode: .fit)
                                }
                            }
                }
                .padding(EdgeInsets(top: -70, leading: 10, bottom: -70, trailing: 5))
            }
        }
            
        }
}
    
