//
//  topbottom.swift
//  MoviesHub
//
//  Created by iMac02 on 10/02/26.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
struct interFace: View {
    var body: some View {
        NavigationStack{
            HStack {
                Text("Hello")
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
    }
}

#Preview {
    interFace()
}
