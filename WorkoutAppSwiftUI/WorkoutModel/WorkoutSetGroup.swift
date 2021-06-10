//
//  WorkoutSetGroup.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 22.03.21.
//

import Foundation

public struct WorkoutSetGroup: Identifiable, Equatable, Hashable {
    
    ///Variables
    
    public var id: String
    public var sets: [WorkoutSet]
    public var exercise: Exercise? { sets.first?.exercise }
    public var isEmpty: Bool { sets.isEmpty }
    public var count: Int { sets.count }
    public var muscleGroup: MuscleGroup? { exercise?.muscleGroup }
    
    
    ///Public Methods
    
    public init() {
        id = UUID().uuidString
        sets = [WorkoutSet]()
    }
    
    public init(_ exercise: Exercise) {
        id = UUID().uuidString
        sets = [WorkoutSet(exercise)]
    }
    
    public mutating func add(set: WorkoutSet) {
        sets.append(set)
    }
    
    public  mutating func remove(set: WorkoutSet) {
        sets = sets.filter { $0 != set }
    }
    
    public mutating func replace(set: WorkoutSet) {
        sets = sets.map { $0 == set ? set : $0 }
    }
    
    public func contains(set: WorkoutSet) -> Bool {
        return !(sets.filter { $0 == set }).isEmpty
    }
    
    subscript(index: Int) -> WorkoutSet {
        get {
            return sets[index]
        }
        set {
            sets[index] = newValue
        }
    }
    
    public static func == (lhr: WorkoutSetGroup, rhs: WorkoutSetGroup) -> Bool {
        return lhr.id == rhs.id
    }
    
}


extension WorkoutSetGroup {
    
    public var repetitions: [Int] {
        var result = [Int]()
        for set in sets {
            if set.repetitions != 0 && !result.contains(set.repetitions) {
                result.append(set.repetitions)
            }
        }
        return result
    }
    
    public var duration: [Int] {
        var result = [Int]()
        for set in sets {
            if set.duration != 0 && !result.contains(set.duration) {
                result.append(set.duration)
            }
        }
        return result
    }
    
    public var weight: [Int] {
        var result = [Int]()
        for set in sets {
            if set.weight != 0.0 && !result.contains(Int(set.weight)) {
                result.append(Int(set.repetitions))
            }
        }
        return result
    }
    
    public var restAfter: [Int] {
        var result = [Int]()
        for set in sets {
            if set.restAfter != 0 && !result.contains(set.restAfter) {
                result.append(set.restAfter)
            }
        }
        return result
    }
    
}


extension WorkoutSetGroup {
    
    static func testSetGroup() -> WorkoutSetGroup {
        var setGroup = WorkoutSetGroup()
        let exercise = Exercise.all().first!
        for _ in 0..<5 {
            let set = WorkoutSet(exercise)
            setGroup.add(set: set)
        }
        return setGroup
    }
    
}
