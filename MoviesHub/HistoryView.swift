//
//  HistoryView.swift
//  MoviesHub
//
//  Created by iMac02 on 23/02/26.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
       ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
           VStack{
               Text("History")
                   .font(.title)
                   .bold()
                   .foregroundColor(.white)
           }
            
        }
    }
    
}

#Preview {
    HistoryView()
}
