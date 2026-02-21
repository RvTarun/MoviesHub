//
//  ContentView.swift
//  MoviesHub
//
//  Created by iMac02 on 10/02/26.
//

import SwiftUI
var MovieD = ["Star Wars": "Action", "Black Widow": "Thriller + Action", "Joker": "Action + Crime","Kalki": "Advanture + Drama", "South": "comedy", "Avatar": "Action + Adventure", "sutter Island": "Horror + Thriller", "24": "Action + comedy", "John Wick 2": "Action", "Golam": "Thriller", "Diesel": "Action + comedy", "RRR": "Documentary", "Lost City": "Documentary", "Oppenheimer": "Action + Crime","Madharaasi": "Drama"]

var userName = ["Arun", "Shubham", "Deepanshu"]
var imgName: [String] = ["Star Wars", "Black Widow", "Joker","Kalki", "South", "Avatar", "sutter Island", "24", "John Wick 2", "Golam", "Diesel", "RRR", "Lost City", "Oppenheimer","Madharaasi"]
var movieCategory: [String] = ["Thriller", "Action", "Comedy", "Horror", "Documentary", "Fantasy", "Science Fiction", "Crime", "Drama"]
struct ContentView: View {
    @StateObject private var auth = AuthViewModel()
    var body: some View{
        Group{
            if auth.isauthenticated {
                NavigationStack{
                    homePagemovieView()
                }
            }
            else {
                AuthView(auth: auth)
            }
        }
        
    }
}
#Preview {
    ContentView()
}

