//
//  FriendManager.swift
//  MoviesHub
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - Friend Model
struct FriendModel: Identifiable {
    var id: String          // friend's UID
    var name: String        // friend's display name from Firestore
    var email: String
}

// MARK: - FriendManager
final class FriendManager: ObservableObject {

    @Published var friends: [FriendModel]     = []
    @Published var overlapMovies: [String]    = []
    @Published var isLoadingFriends: Bool     = false
    @Published var isLoadingOverlap: Bool     = false
    @Published var errorMessage: String?      = nil
    @Published var successMessage: String?    = nil

    private let db  = Firestore.firestore()
    private var uid: String? { Auth.auth().currentUser?.uid }

    // MARK: - Add Friend by UID
    func addFriend(friendUID: String, completion: @escaping () -> Void) {
        errorMessage   = nil
        successMessage = nil

        let trimmed = friendUID.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a friend code."
            return
        }
        guard let myUID = uid else {
            errorMessage = "You are not logged in."
            return
        }
        guard trimmed != myUID else {
            errorMessage = "You cannot add yourself."
            return
        }

        isLoadingFriends = true

        // First verify the friend UID exists in users collection
        db.collection("users").document(trimmed).getDocument { [weak self] snapshot, error in
            guard let self else { return }

            if let error {
                DispatchQueue.main.async {
                    self.isLoadingFriends = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let snapshot, snapshot.exists else {
                DispatchQueue.main.async {
                    self.isLoadingFriends = false
                    self.errorMessage = "No user found with that code."
                }
                return
            }

            // Write mutual friend connection
            let batch = self.db.batch()

            let myRef    = self.db.collection("friends").document(myUID)
                               .collection("friendList").document(trimmed)
            let theirRef = self.db.collection("friends").document(trimmed)
                               .collection("friendList").document(myUID)

            batch.setData(["addedAt": FieldValue.serverTimestamp()], forDocument: myRef)
            batch.setData(["addedAt": FieldValue.serverTimestamp()], forDocument: theirRef)

            batch.commit { [weak self] err in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.isLoadingFriends = false
                    if let err {
                        self.errorMessage = err.localizedDescription
                    } else {
                        self.successMessage = "Friend added!"
                        self.loadFriends()
                        completion()
                    }
                }
            }
        }
    }

    // MARK: - Remove Friend
    func removeFriend(friendUID: String) {
        guard let myUID = uid else { return }

        let myRef    = db.collection("friends").document(myUID)
                         .collection("friendList").document(friendUID)
        let theirRef = db.collection("friends").document(friendUID)
                         .collection("friendList").document(myUID)

        let batch = db.batch()
        batch.deleteDocument(myRef)
        batch.deleteDocument(theirRef)
        batch.commit { [weak self] _ in
            DispatchQueue.main.async {
                self?.friends.removeAll { $0.id == friendUID }
                self?.overlapMovies = []
            }
        }
    }

    // MARK: - Load Friends List
    func loadFriends() {
        guard let myUID = uid else { return }
        isLoadingFriends = true

        db.collection("friends").document(myUID).collection("friendList")
          .getDocuments { [weak self] snapshot, error in
              guard let self else { return }

              if let error {
                  DispatchQueue.main.async {
                      self.isLoadingFriends = false
                      self.errorMessage = error.localizedDescription
                  }
                  return
              }

              let friendUIDs = snapshot?.documents.map { $0.documentID } ?? []
              guard !friendUIDs.isEmpty else {
                  DispatchQueue.main.async {
                      self.friends = []
                      self.isLoadingFriends = false
                  }
                  return
              }

              // Fetch each friend's name from users collection
              let group = DispatchGroup()
              var loaded: [FriendModel] = []

              for fUID in friendUIDs {
                  group.enter()
                  self.db.collection("users").document(fUID).getDocument { snap, _ in
                      defer { group.leave() }
                      let data  = snap?.data()
                      let name  = data?["name"]  as? String ?? "Unknown"
                      let email = data?["email"] as? String ?? ""
                      loaded.append(FriendModel(id: fUID, name: name, email: email))
                  }
              }

              group.notify(queue: .main) {
                  self.friends = loaded.sorted { $0.name < $1.name }
                  self.isLoadingFriends = false
              }
          }
    }

    // MARK: - Compute Watchlist Overlap
    func loadOverlap(friendUID: String, myBookmarkNames: [String]) {
        isLoadingOverlap = true
        overlapMovies    = []

        db.collection("users").document(friendUID).collection("bookmarks")
          .getDocuments { [weak self] snapshot, error in
              guard let self else { return }
              DispatchQueue.main.async {
                  self.isLoadingOverlap = false
                  if let error {
                      self.errorMessage = error.localizedDescription
                      return
                  }
                  let friendMovies = snapshot?.documents
                      .compactMap { $0.data()["imgName"] as? String } ?? []

                  let mySet     = Set(myBookmarkNames)
                  let friendSet = Set(friendMovies)
                  self.overlapMovies = Array(mySet.intersection(friendSet)).sorted()
              }
          }
    }
}

// MARK: - BookmarkStore Extension (Firestore sync)
extension BookmarkStore {

    /// Call this instead of the plain toggle so bookmarks are written to Firestore.
    func toggleWithSync(_ card: CardModel) {
        guard let uid = Auth.auth().currentUser?.uid else {
            toggle(card)     // fallback: in-memory only
            return
        }
        let db  = Firestore.firestore()
        let ref = db.collection("users").document(uid).collection("bookmarks")

        if isBookmarked(card) {
            // Remove
            toggle(card)
            ref.document(card.imgName).delete()
        } else {
            // Add
            toggle(card)
            ref.document(card.imgName).setData([
                "imgName"  : card.imgName,
                "category" : card.category,
                "savedAt"  : FieldValue.serverTimestamp()
            ])
        }
    }
}


