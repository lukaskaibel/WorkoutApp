//
//  IDFactory.swift
//  WorkoutApp
//
//  Created by Lukas Kaibel on 09.02.21.
//

import Foundation

public struct IDFactory {
    
    ///Variables
    
    private static var counter = 0
    
    ///Public Methods
    
    public static func getUnique() -> Int {
        IDFactory.counter += 1
        return IDFactory.counter
    }
    
}
