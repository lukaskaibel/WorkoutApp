//
//  SearchBar.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 27.04.21.
//

import SwiftUI


struct SearchBar: View {
    
    //MARK: Variables
    
    @Binding var text: String
    let placeholder: String
 
    @Binding var isEditing: Bool
 
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
             
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
            .onTapGesture {
                self.isEditing = true
            }
    }
}
