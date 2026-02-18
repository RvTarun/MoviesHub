//
//  WatchlistIteamView.swift
//  MoviesHub
//
//  Created by iMac02 on 11/02/26.
//

import SwiftUI
struct movieIteam: View {
    
    var currentMovie: String = ""
    var currentCategory: String = ""
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Rectangle()
                    .foregroundStyle(Color.black)
                    .frame(height: 60)
                topView()
                ScrollView{
                    VStack(alignment: .leading){
                        Image("\(currentMovie)")
                            .resizable()
                            .frame(height: 400)
                        Text("Title: \(currentMovie)")
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 22))
                        Text("Category: \(currentCategory)")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 18))
                        Spacer()
                        Text("Cast: Ajay Devgn, Ranveer Singh, Alia Bhatt, Deepika Padukone, John Abraham, Rami Malek, Javed Jaffrey, Anushka Sharma, Aamir Khan, Kunal Nayyar, Abhishek Bachchan, Sonam Kapoor, Alia Bhatt, Aamir Khan, Kunal Nayyar, Abhishek Bachchan, Sonam Kapoor")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 15))
                       ForEach(1..<5, id: \.self){i in
                           HStack{
                               Image("24")
                                   .resizable()
                                   .frame(width: 150, height: 150)
                                   .cornerRadius(20)
                               VStack(alignment: .leading){
                                   Text("Ajay Devgn")
                                       .foregroundStyle(Color.white)
                                       .font(.system(size: 22).bold())
                                   Text("as Robin")
                                       .foregroundStyle(Color.white)
                                       .font(.system(size: 18))

                               }
                           }
                        }
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
    movieIteam()
}

struct topView: View {
    var body: some View {
        HStack{
            NavigationLink{
                WatchList()
            }label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
            }
            
            Spacer()
            Text("Watchlist")
                .font(.title)
                .bold()
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .foregroundStyle(Color.white.opacity(0.9))
    }
}

