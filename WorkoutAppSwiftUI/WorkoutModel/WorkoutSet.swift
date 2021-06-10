//
//  WorkoutSet.swift
//  WorkoutApp
//
//  Created by Lukas Kaibel on 09.02.21.
//

import Foundation


enum SetAttribute: String {
    case repetitions = "Repetitions", weight = "Weight", duration = "Duration", restAfter = "Rest"
    
    var unit: String {
        self == .repetitions ? "" : self == .weight ? " kg" : " s"
    }
}

//------------------------------------------------

public struct WorkoutSet: Identifiable, Equatable, Hashable {
    
    ///Variables
    
    public var id: String
    public var exercise: Exercise
    public var duration: Int
    public var repetitions: Int
    public var weight: Float
    public var restAfter: Int
    
    ///Public Methods
    
    public init() {
        id = UUID().uuidString
        exercise = Exercise()
        duration = 0
        repetitions = 0
        weight = 0.0
        restAfter = 0
    }
    
    public init(_ exercise: Exercise) {
        id = UUID().uuidString
        self.exercise = exercise
        duration = 0
        repetitions = 0
        weight = 0.0
        restAfter = 0
    }
    
    public func duplicate() -> WorkoutSet {
        var set = WorkoutSet()
        set.exercise = exercise
        set.duration = duration
        set.repetitions = repetitions
        set.weight = weight
        set.restAfter = restAfter
        return set
    }
    
    public static func == (lhs: WorkoutSet, rhs: WorkoutSet) -> Bool {
        return lhs.id == rhs.id
    }
        
    public static func testSet() -> WorkoutSet {
        var set = WorkoutSet()
        var exercise = Exercise()
        exercise.set(name: "Pushups")
        set.exercise = exercise
        set.duration = 45
        set.restAfter = 10
        set.weight = 20.0
        set.repetitions = 12
        return set
    }
    
}

