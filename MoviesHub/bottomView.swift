//
//  bottom.swift
//  MoviesHub
//
//  Created by iMac02 on 11/02/26.
//

import SwiftUI
struct bottom: View {
    var body: some View {
        VStack{
            Divider()
            HStack{
                Spacer()
                VStack(alignment: .center){
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 30, height: 25)
                    Text("Home")
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .center){
                    Image(systemName: "play.rectangle.on.rectangle")
                        .resizable()
                        .frame(width: 30, height: 25)
                    Text("Watchlist")
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .center){
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 25)
                    Text("Profile")
                        .font(.caption)
                }
                Spacer()
            }
            .foregroundStyle(Color(.secondaryLabel))
            
        }
        .frame(height: 50)
    }
    
}

#Preview {
    bottom()
}
