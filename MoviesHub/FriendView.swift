//
//  FriendView.swift
//  MoviesHub
//

import SwiftUI
import FirebaseAuth

// MARK: - FriendView (Main Screen)
struct FriendView: View {
    @StateObject private var friendManager = FriendManager()
    @EnvironmentObject var bookmarkStore: BookmarkStore

    @State private var friendCodeInput: String   = ""
    @State private var selectedFriend: FriendModel? = nil
    @State private var showAddField: Bool        = false
    @State private var myUID: String             = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // ── My friend code ──────────────────────────────
                        MyCodeCard(uid: myUID)
                            .padding(.horizontal)
                            .padding(.top, 16)

                        // ── Add friend ──────────────────────────────────
                        AddFriendSection(
                            input: $friendCodeInput,
                            showField: $showAddField,
                            isLoading: friendManager.isLoadingFriends,
                            errorMessage: friendManager.errorMessage,
                            successMessage: friendManager.successMessage
                        ) {
                            friendManager.addFriend(friendUID: friendCodeInput) {
                                friendCodeInput = ""
                                showAddField    = false
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)

                        // ── Friends list ────────────────────────────────
                        SectionHeader(title: "Friends (\(friendManager.friends.count))")
                            .padding(.horizontal)
                            .padding(.top, 24)

                        if friendManager.isLoadingFriends {
                            HStack { Spacer(); ProgressView().tint(.white); Spacer() }
                                .padding()
                        } else if friendManager.friends.isEmpty {
                            EmptyStateLabel(text: "No friends yet. Add one above.")
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(friendManager.friends) { friend in
                                    FriendRow(
                                        friend: friend,
                                        isSelected: selectedFriend?.id == friend.id
                                    ) {
                                        // Select / deselect — show MY favourites on tap
                                        if selectedFriend?.id == friend.id {
                                            selectedFriend = nil
                                        } else {
                                            selectedFriend = friend
                                        }
                                    } onDelete: {
                                        friendManager.removeFriend(friendUID: friend.id)
                                        if selectedFriend?.id == friend.id {
                                            selectedFriend = nil
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // ── Watch Together — meri saari Favourites dikhao ──
                        if let friend = selectedFriend {
                            WatchTogetherSection(
                                friendName: friend.name,
                                movies: bookmarkStore.items   // <-- meri BookmarkStore ki items
                            )
                            .padding(.top, 24)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                myUID = Auth.auth().currentUser?.uid ?? ""
                friendManager.loadFriends()
            }
        }
    }
}

// MARK: - My Code Card
private struct MyCodeCard: View {
    let uid: String

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your friend code")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            HStack(spacing: 10) {
                Text(uid.isEmpty ? "Loading…" : uid)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button {
                    UIPasteboard.general.string = uid
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        copied = false
                    }
                } label: {
                    Text(copied ? "Copied!" : "Copy")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(copied ? .green : .white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(8)
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.08))
            .cornerRadius(10)
        }
    }
}

// MARK: - Add Friend Section
private struct AddFriendSection: View {
    @Binding var input: String
    @Binding var showField: Bool
    let isLoading: Bool
    let errorMessage: String?
    let successMessage: String?
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showField.toggle() }
            } label: {
                HStack {
                    Image(systemName: showField ? "minus.circle" : "plus.circle")
                    Text(showField ? "Cancel" : "Add a friend")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.red)
            }

            if showField {
                HStack(spacing: 8) {
                    TextField("Paste friend's UID", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.system(size: 13, design: .monospaced))

                    Button(action: onAdd) {
                        if isLoading {
                            ProgressView().tint(.white)
                                .frame(width: 50)
                        } else {
                            Text("Add")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50)
                        }
                    }
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(8)
                    .disabled(isLoading || input.isEmpty)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))

                if let err = errorMessage {
                    Text(err)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
                if let ok = successMessage {
                    Text(ok)
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                }
            }
        }
    }
}

// MARK: - Section Header
private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
    }
}

// MARK: - Empty State
private struct EmptyStateLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .padding(.top, 8)
    }
}

// MARK: - Friend Row
private struct FriendRow: View {
    let friend: FriendModel
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Avatar circle
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.3))
                    .frame(width: 42, height: 42)
                Text(String(friend.name.prefix(1)).uppercased())
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text(friend.email)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            // Overlap badge
            if isSelected {
                Image(systemName: "film.stack")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }

            // Delete
            Button(action: onDelete) {
                Image(systemName: "person.badge.minus")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected
                      ? Color.red.opacity(0.15)
                      : Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.red.opacity(0.5) : Color.clear,
                        lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Watch Together Section
// Ab yeh section meri saari BookmarkStore ki movies dikhata hai
// jab bhi koi friend select hota hai
private struct WatchTogetherSection: View {
    let friendName: String
    let movies: [CardModel]   // BookmarkStore.items — meri saari favourites

    private let count = [GridItem(.flexible(minimum: 50, maximum: 250))]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ── Header ──────────────────────────────────────────────
            HStack(spacing: 8) {
                Image(systemName: "popcorn.fill")
                    .foregroundColor(.red)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Watch Together with \(friendName)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Your saved favourites")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            if movies.isEmpty {
                // Koi favourite nahi hai abhi
                VStack(alignment: .leading, spacing: 6) {
                    Text("No favourites yet!")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text("Bookmark movies from the home screen — they'll appear here so you and \(friendName) can watch together.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

            } else {
                // Movie count badge
                Text("\(movies.count) movie\(movies.count == 1 ? "" : "s") in your favourites")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                // Horizontal scrolling movie cards
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: count, spacing: 12) {
                        ForEach(movies) { item in
                            NavigationLink {
                                movieIteam(
                                    currentMovie: item.imgName,
                                    currentCategory: item.category
                                )
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    // Poster image
                                    Image(item.imgName)
                                        .resizable()
                                        .aspectRatio(2/3, contentMode: .fill)
                                        .frame(width: 110, height: 165)
                                        .cornerRadius(10)
                                        .clipped()

                                    // Dark gradient for readability
                                    LinearGradient(
                                        colors: [.clear, .black.opacity(0.8)],
                                        startPoint: .center,
                                        endPoint: .bottom
                                    )
                                    .cornerRadius(10)

                                    // Movie title at bottom
                                    Text(item.imgName)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.bottom, 6)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)

                                    // Play icon top-right
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white.opacity(0.85))
                                        .padding(6)
                                        .frame(maxWidth: .infinity,
                                               maxHeight: .infinity,
                                               alignment: .topTrailing)
                                }
                                .frame(width: 110, height: 165)
                                .shadow(color: .black.opacity(0.5), radius: 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .frame(height: 185)
                }
            }
        }
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    FriendView()
        .environmentObject(BookmarkStore())
}
