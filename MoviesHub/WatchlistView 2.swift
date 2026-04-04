////
////  WatchlistView.swift
////  MoviesHub
////
////  Created by iMac02 on 11/02/26.
////
//
//import SwiftUI
//import Combine
//
//// MARK: - BookmarkStore
//class BookmarkStore: ObservableObject {
//
//    @Published var items: [CardModel] = []
//
//    func isBookmarked(_ card: CardModel) -> Bool {
//        items.contains(where: { $0.imgName == card.imgName && $0.category == card.category })
//    }
//
//    func toggle(_ card: CardModel) {
//        if let idx = items.firstIndex(where: { $0.imgName == card.imgName && $0.category == card.category }) {
//            items.remove(at: idx)
//        } else {
//            var saved = card
//            saved.isMarked = true
//            items.append(saved)
//        }
//    }
//}
//
//// MARK: - CardModel
//struct CardModel: Identifiable {
//    var id       = UUID()
//    var imgName  : String
//    var category : String
//    var isMarked : Bool
//}
//
//// MARK: - WatchList
//struct WatchList: View {
//    @State private var card: [CardModel] = []
//    @EnvironmentObject var bookmarkStore: BookmarkStore
//
//    init() {
//        _card = State(initialValue: newCard())
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                VStack {
//                    Rectangle()
//                        .foregroundStyle(Color.black)
//                        .frame(height: 60)
//                    TopView()
//                    ScrollView {
//                        ForEach(card.indices, id: \.self) { index in
//                            ZStack {
//                                Rectangle()
//                                    .foregroundStyle(Color.white.opacity(0.1))
//                                    .cornerRadius(10)
//                                HStack(alignment: .top) {
//                                    NavigationLink {
//                                        movieIteam(
//                                            currentMovie: "\(card[index].imgName)",
//                                            currentCategory: "\(card[index].category)"
//                                        )
//                                    } label: {
//                                        Image("\(card[index].imgName)")
//                                            .resizable()
//                                            .frame(width: 100, height: 150)
//                                            .cornerRadius(10)
//                                            .clipped()
//                                    }
//
//                                    VStack(alignment: .leading) {
//                                        Text("\(card[index].imgName)")
//                                            .font(.system(size: 22, weight: .bold))
//                                            .foregroundColor(.white)
//                                        Text("\(card[index].category)")
//                                            .font(.system(size: 18))
//                                            .foregroundStyle(Color.gray)
//                                    }
//                                    .padding(10)
//                                    Spacer()
//
//                                    // ← toggleWithSync writes to Firestore so friends see your bookmarks
//                                    Button {
//                                        card[index].isMarked.toggle()
//                                        bookmarkStore.toggleWithSync(card[index])
//                                    } label: {
//                                        Image(systemName: (card[index].isMarked || bookmarkStore.isBookmarked(card[index]))
//                                              ? "bookmark.fill" : "bookmark")
//                                            .foregroundStyle(Color.gray)
//                                            .padding(10)
//                                    }
//                                }
//                                .cornerRadius(10)
//                            }
//                        }
//                    }
//                }
//                WatchlistbottomView()
//            }
//            .ignoresSafeArea()
//            .background(Color.black)
//        }
//        .toolbar(.hidden)
//    }
//
//    func newCard() -> [CardModel] {
//        MovieD.sorted(by: { $0.key < $1.key }).map {
//            CardModel(imgName: $0.key, category: $0.value, isMarked: false)
//        }
//    }
//}
//
//#Preview {
//    WatchList().environmentObject(BookmarkStore())
//}
//
//// MARK: - TopView
//struct TopView: View {
//    var body: some View {
//        HStack {
//            Spacer()
//            Text("Watchlist")
//                .font(.title)
//                .bold()
//                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//            Spacer()
//            Image(systemName: "magnifyingglass")
//                .resizable()
//                .frame(width: 25, height: 25)
//        }
//        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//        .foregroundStyle(Color.white.opacity(0.9))
//    }
//}
//
//// MARK: - WatchlistbottomView
//struct WatchlistbottomView: View {
//    var body: some View {
//        NavigationStack {
//            VStack {
//                HStack {
//                    Spacer()
//                    NavigationLink {
//                        homePagemovieView()
//                    } label: {
//                        VStack(alignment: .center) {
//                            Image(systemName: "house")
//                                .resizable()
//                                .frame(width: 30, height: 25)
//                            Text("Home")
//                                .font(.caption)
//                        }
//                    }
//
//                    Spacer()
//                    VStack(alignment: .center) {
//                        Image(systemName: "play.rectangle.on.rectangle")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                        Text("Watchlist")
//                            .font(.caption)
//                    }
//                    .foregroundStyle(Color.red)
//                    Spacer()
//                    NavigationLink {
//                        ProfileView()
//                    } label: {
//                        VStack(alignment: .center) {
//                            Image(systemName: "person")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                            Text("Profile")
//                                .font(.caption)
//                        }
//                    }
//                    Spacer()
//                }
//                .foregroundStyle(Color(.white))
//                .overlay(
//                    Rectangle()
//                        .frame(height: 1)
//                        .foregroundColor(.gray)
//                        .offset(y: -32)
//                )
//            }
//            .frame(height: 50)
//        }
//    }
//}
