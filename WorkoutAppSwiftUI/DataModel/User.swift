//
//  User.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 12.05.21.
//

import Foundation

struct User {
    
    private let id: UUID
    var username: String
    
    init(username: String) {
        id = UUID()
        self.username = username
    }
    
}
