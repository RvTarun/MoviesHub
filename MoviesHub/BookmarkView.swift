//
//  HistoryView.swift
//  MoviesHub
//
//  Created by iMac02 on 23/02/26.
//

import SwiftUI

struct BookmarkView: View {
    @EnvironmentObject var bookmarkStore: BookmarkStore

    var body: some View {
        NavigationStack {
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    if bookmarkStore.items.isEmpty {
                        Text("No bookmarks yet")
                            .foregroundStyle(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(bookmarkStore.items) { item in
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    HStack(alignment: .top){
                                        NavigationLink{
                                            movieIteam(currentMovie: "\(item.imgName)", currentCategory: "\(item.category)")
                                        }label:{
                                            Image("\(item.imgName)")
                                                .resizable()
                                                .frame(width:100, height: 150)
                                                .cornerRadius(10)
                                                .clipped()
                                        }
                                        VStack(alignment: .leading){
                                            Text("\(item.imgName)")
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundColor(.white)
                                            Text("\(item.category)")
                                                .font(.system(size: 18))
                                                .foregroundStyle(Color.gray)
                                        }
                                        .padding(10)
                                        Spacer()
                                        Button{
                                            bookmarkStore.toggle(item)
                                        }label: {
                                            Image(systemName: "bookmark.fill")
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
                .padding()
            }
        }
    }
}
#Preview {
    BookmarkView()
        .environmentObject(BookmarkStore())
}

