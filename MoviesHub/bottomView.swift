//
//  bottom.swift
//  MoviesHub
//
//  Created by iMac02 on 11/02/26.
//

import SwiftUI
struct bottom: View {
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Spacer()
                    NavigationLink{
                        ContentView()
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
                        watchList()
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

#Preview {
    ContentView()
}
