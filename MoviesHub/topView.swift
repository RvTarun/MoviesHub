//
//  topbottom.swift
//  MoviesHub
//
//  Created by iMac02 on 10/02/26.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
struct interFace: View {
    @State private var userName: String = "Guest"
    var body: some View {
        NavigationStack{
            HStack {
                Text("Hello, \(userName)")
                    .font(.system(size: 22))
                Spacer()
                Image(systemName: "airplay.video")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
            }
            .foregroundStyle(Color.gray)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            .frame(height: 50)
            Divider()
        }
        .onAppear {
            fetchUserName()
        }
    }
    func fetchUserName() {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
            
            let db = Firestore.firestore()
            
            db.collection("users").document(uid).getDocument { document, error in
                if let document = document, document.exists {
                    if let name = document.get("name") as? String {
                        self.userName = name
                    }
                } else {
                    print("Document not found")
                }
            }
        }
}

#Preview {
    interFace()
}
