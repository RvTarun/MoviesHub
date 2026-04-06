//
//  WatchlistIteamView.swift
//  MoviesHub
//

import SwiftUI
import AVKit

// MARK: - Movie Detail + Video Player View
struct movieIteam: View {

    var currentMovie: String = ""
    var currentCategory: String = ""

    /// Maps movie image-name → bundled video filename (no extension).
    /// Add more entries here as you add more .mp4 files to the Xcode bundle.
    private static let videoMap: [String: String] = [
        "Raja": "Raja",
        "Rama": "Rama "   // the file on disk is "Rama .mp4" (space before .mp4)
    ]

    @State private var showPlayer = false
    @State private var player: AVPlayer? = nil

    var body: some View {
        NavigationStack {
            VStack {
                Rectangle()
                    .foregroundStyle(Color.black)
                    .frame(height: 60)

                topView()

                ScrollView {
                    VStack(alignment: .leading) {

                        // ── Poster ──────────────────────────────────────
                        Image(currentMovie)
                            .resizable()
                            .frame(height: 400)

                        // ── Title + Play button ──────────────────────────
                        HStack {
                            Text("Title: \(currentMovie)")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 22))

                            Spacer()

                            // Play button → opens full-screen video
                            Button {
                                playVideo()
                            } label: {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.red)
                                    .padding()
                            }
                        }

                        Text("Category: \(currentCategory)")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 18))

                        Spacer()

                        Text("Cast: Ajay Devgn, Ranveer Singh, Alia Bhatt, Deepika Padukone, John Abraham, Rami Malek, Javed Jaffrey, Anushka Sharma, Aamir Khan, Kunal Nayyar, Abhishek Bachchan, Sonam Kapoor")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 15))
                    }
                }
            }
            .ignoresSafeArea()
            .background(Color.black)

            // ── Full-screen video player ─────────────────────────────
            .fullScreenCover(isPresented: $showPlayer, onDismiss: {
                player?.pause()
                player = nil
            }) {
                if let activePlayer = player {
                    ZStack(alignment: .topTrailing) {
                        Color.black.ignoresSafeArea()

                        VideoPlayer(player: activePlayer)
                            .ignoresSafeArea()
                            .onAppear { activePlayer.play() }

                        // Close button overlay
                        Button {
                            showPlayer = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(.white)
                                .shadow(radius: 4)
                                .padding(EdgeInsets(top: 54, leading: 0, bottom: 0, trailing: 16))
                        }
                    }
                } else {
                    // Video file not found in bundle
                    ZStack {
                        Color.black.ignoresSafeArea()
                        VStack(spacing: 20) {
                            Image(systemName: "film.slash")
                                .font(.system(size: 52))
                                .foregroundStyle(.gray)
                            Text("Video not available for")
                                .foregroundStyle(.gray)
                            Text("\"\(currentMovie)\"")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.system(size: 18))
                            Button("Close") { showPlayer = false }
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.red)
                                .padding(.top, 8)
                        }
                        .padding()
                    }
                }
            }
        }
        .toolbar(.hidden)
    }

    // MARK: - Video Playback Helper
    private func playVideo() {
        // 1. Look up the bundle resource name from the map
        if let resourceName = Self.videoMap[currentMovie],
           let url = Bundle.main.url(forResource: resourceName, withExtension: "mp4") {
            player = AVPlayer(url: url)
            showPlayer = true
            return
        }
        // 2. Fallback: try the movie name itself as the resource name
        if let url = Bundle.main.url(forResource: currentMovie, withExtension: "mp4") {
            player = AVPlayer(url: url)
            showPlayer = true
            return
        }
        // 3. No video found — show "not available" cover
        player = nil
        showPlayer = true
    }
}

// MARK: - Shared Top Navigation Bar
struct topView: View {
    var body: some View {
        HStack {
            NavigationLink {
                WatchList()
            } label: {
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
//            Image(systemName: "magnifyingglass")
//                .resizable()
//                .frame(width: 25, height: 25)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .foregroundStyle(Color.white.opacity(0.9))
    }
}

#Preview {
    movieIteam(currentMovie: "Raja", currentCategory: "Action")
}
