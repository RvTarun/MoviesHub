//
//  topbottom.swift
//  MoviesHub
//
//  Created by iMac02 on 10/02/26.
//
import SwiftUI
struct interFace: View {
    var body: some View {
        HStack {
            Text("Hii,\(userName[0])")
                .font(.system(size: 22))
                .foregroundStyle(Color.white)
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundStyle(Color.gray)
                .frame(width: 50, height: 50)
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        .frame(height: 50)
        Divider()
        
    }
    
}

#Preview {
    ContentView()
}
