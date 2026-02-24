//
//  HistoryView.swift
//  MoviesHub
//
//  Created by iMac02 on 23/02/26.
//

import SwiftUI

struct BookmarkView: View {
    var body: some View {
       ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
           VStack{
               Text("Saved Movies / Web Series")
                   .font(.title)
                   .bold()
                   .foregroundColor(.white)
           }
            
        }
    }
    
}

#Preview {
    BookmarkView()
}
