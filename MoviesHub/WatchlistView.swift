//
//  WatchlistView.swift
//  MoviesHub
//
//  Created by iMac02 on 11/02/26.
//

import SwiftUI

struct CardModel: Identifiable {
    var id = UUID()
    var imgName: String
    var category: String
    var isMarked: Bool
}


struct WatchList: View {
//@State var isSaved: Bool = false
    @State private var card: [CardModel] = []
    
    
    init(){
        _card = State(initialValue: newCard())
       
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    Rectangle()
                        .foregroundStyle(Color.black)
                        .frame(height: 60)
                    TopView()
                   ScrollView{
                       ForEach(card.indices, id: \.self) { index in
                           ZStack{
                               Rectangle()
                                   .foregroundStyle(Color.white.opacity(0.1))
                                   .cornerRadius(10)
                               HStack(alignment: .top){
                                   NavigationLink{
                                       movieIteam(currentMovie: "\(card[index].imgName)", currentCategory: "\(card[index].category)")
                                   }label:{
                                       Image("\(card[index].imgName)")
                                           .resizable()
                                           .frame(width:100, height: 150)
                                           .cornerRadius(10)
                                           .clipped()
                                   }
                                   
                                   VStack(alignment: .leading){
                                       Text("\(card[index].imgName)")
                                           .font(.system(size: 22, weight: .bold))
                                           .foregroundColor(.white)
                                       Text("\(card[index].category)")
                                           .font(.system(size: 18))
                                           .foregroundStyle(Color.gray)
                                   }
                                   .padding(10)
                                   Spacer()
                                   Button{
                                       card[index].isMarked.toggle()
                                   }label: {
                                       Image(systemName:  card[index].isMarked ? "bookmark.fill": "bookmark")
                                           .foregroundStyle(Color.gray)
                                           .padding(10)
                                   }
                               }
                               .cornerRadius(10)
                           }
                        }
                    }
                }
                WatchlistbottomView()
            }
            .ignoresSafeArea()
            .background(Color.black)
        }
        .toolbar(.hidden)

    }
    
    func newCard() -> [CardModel]{
        var cards: [CardModel] = []
        
        // Sort the dictionary by key and iterate to build cards
        for (key, value) in MovieD.sorted(by: { $0.key < $1.key }) {
            cards.append(CardModel(imgName: String(describing: key),
                                   category: String(describing: value),
                                   isMarked: false))
        }
        return cards
    }

}

#Preview {
    WatchList()
}

struct TopView: View {
    var body: some View {
        HStack{
            NavigationLink{
                homePagemovieView()
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

struct WatchlistbottomView: View {
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
                        VStack(alignment: .center){
                            Image(systemName: "play.rectangle.on.rectangle")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Watchlist")
                                .font(.caption)
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
