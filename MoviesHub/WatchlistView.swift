//
//  WatchlistView.swift
//  MoviesHub
//
//  Created by iMac02 on 11/02/26.
//

import SwiftUI
struct watchList: View {
@State var isSaved: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                MovieContent(
                    isSaved: $isSaved
                    
                )
                bottom()
            }
            .ignoresSafeArea()
            .background(Color.black)
        }
        .toolbar(.hidden)

    }
}

#Preview {
    watchList()
}

struct TopView: View {
    var body: some View {
        HStack{
            NavigationLink{
                ContentView()
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

struct MovieContent: View {
    @Binding var isSaved: Bool
    var body: some View {
        VStack{
            Rectangle()
                .foregroundStyle(Color.black)
                .frame(height: 60)
            TopView()
           ScrollView{
               ForEach(MovieD.sorted(by: <), id: \.key) { key, value in
                   ZStack{
                       Rectangle()
                           .foregroundStyle(Color.white.opacity(0.1))
                           .cornerRadius(10)
                       HStack(alignment: .top){
                           NavigationLink{
                               movieIteam(currentMovie: "\(key)", currentCategory: "\(value)")
                           }label:{
                               Image("\(key)")
                                   .resizable()
                                   .frame(width:100, height: 150)
                                   .cornerRadius(10)
                                   .clipped()
                           }
                           
                           VStack(alignment: .leading){
                               Text("\(key)")
                                   .font(.system(size: 22, weight: .bold))
                                   .foregroundColor(.white)
                               Text("\(value)")
                                   .font(.system(size: 18))
                                   .foregroundStyle(Color.gray)
                           }
                           .padding(10)
                           Spacer()
                           Button{
                               isSaved.toggle()
                           }label: {
                               Image(systemName: isSaved ? "bookmark.fill": "bookmark")
                                   .foregroundStyle(Color.gray)
                                   .padding(10)
                           }
                       }
                       .cornerRadius(10)
                   }
                }
            }
        }
    }
}
