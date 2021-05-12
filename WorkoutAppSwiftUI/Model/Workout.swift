//
//  Workout.swift
//  WorkoutApp
//
//  Created by Lukas Kaibel on 09.02.21.
//

import Foundation

public struct Workout: Identifiable {
    
    ///Variables
    
    public var id: String
    public var name: String
    public var setGroups: [WorkoutSetGroup]
    
    ///Public Methods
    
    public init() {
        id = UUID().uuidString
        name = ""
        setGroups = [WorkoutSetGroup]()
    }
    
    ///Public Methods
    
    public mutating func set(name: String) {
        if !name.isEmpty { self.name = name }
    }
    
    public mutating func add(set: WorkoutSet) {
        if setGroups.isEmpty { setGroups.append(WorkoutSetGroup()) }
        if setGroups.last!.exercise == set.exercise || setGroups.last!.isEmpty {
            setGroups[setGroups.count-1].add(set: set)
        } else {
            var setGroup = WorkoutSetGroup()
            setGroup.add(set: set)
            setGroups.append(setGroup)
        }
    }
    
    public mutating func add(set: WorkoutSet, for setGroup: WorkoutSetGroup) {
        for group in setGroups {
            if setGroup == group {
                var newGroup = group
                newGroup.add(set: set)
                replace(setGroup: newGroup)
            }
        }
    }
    
    public mutating func remove(set: WorkoutSet) {
        for setGroup in setGroups {
            var temporaryGroup = setGroup
            temporaryGroup.remove(set: set)
            replace(setGroup: temporaryGroup)
        }
    }
    
    public mutating func replace(set: WorkoutSet) {
        for setGroup in setGroups {
            var temporaryGroup = setGroup
            temporaryGroup.replace(set: set)
            replace(setGroup: temporaryGroup)
        }
    }
    
    public mutating func add(setGroup: WorkoutSetGroup) {
        if !setGroups.contains(setGroup) { setGroups.append(setGroup) }
    }
    
    public mutating func add(setGroup: WorkoutSetGroup, at index: Int) {
        var tmpSetGroups = [WorkoutSetGroup]()
        for i in 0..<setGroups.count+1 {
            if i < index { tmpSetGroups.append(setGroups[i]) }
            else if i == index { tmpSetGroups.append(setGroup) }
            else { tmpSetGroups.append(setGroups[i-1]) }
        }
        setGroups = tmpSetGroups
    }
    
    public mutating func add(setGroups: [WorkoutSetGroup], at index: Int) {
        var tmpSetGroups = [WorkoutSetGroup]()
        for i in 0..<self.setGroups.count+1 {
            if i < index { tmpSetGroups.append(self.setGroups[i]) }
            else if i == index { tmpSetGroups.append(contentsOf: setGroups) }
            else { tmpSetGroups.append(self.setGroups[i-1]) }
        }
        self.setGroups = tmpSetGroups
    }
    
    public mutating func add(setGroups: [WorkoutSetGroup]) {
        for setGroup in setGroups {
            add(setGroup: setGroup)
        }
    }
    
    public mutating func remove(setGroup: WorkoutSetGroup) {
        setGroups = setGroups.filter { $0 != setGroup }
    }
    
    public mutating func replace(setGroup: WorkoutSetGroup) {
        setGroups = setGroups.map { return $0 == setGroup ? setGroup : $0 }
    }
    
    public func toExecutable() -> WorkoutExecutable {
        return WorkoutExecutable(workout: self)
    }
    
}

extension Workout: Equatable, Hashable {
    
    public static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension Workout {
    
    public var exercises: [Exercise] {
        var result = [Exercise]()
        for set in sets {
            if set.exercise != result.last {
                result.append(set.exercise)
            }
        }
        return result
    }
    
    public var sets: [WorkoutSet] {
        get {
            var result = [WorkoutSet]()
            for setGroup in setGroups {
                result.append(contentsOf: setGroup.sets)
            }
            return result
        }
        set {
            var newSetGroups = [WorkoutSetGroup]()
            for set in newValue {
                if newSetGroups.isEmpty { newSetGroups.append(WorkoutSetGroup()) }
                if newSetGroups.last!.exercise == set.exercise || newSetGroups.last!.isEmpty {
                    newSetGroups[newSetGroups.count-1].add(set: set)
                } else {
                    var setGroup = WorkoutSetGroup()
                    setGroup.add(set: set)
                    newSetGroups.append(setGroup)
                }
            }
        }
    }

    public var muscleGroups: [MuscleGroup] {
        var result = [MuscleGroup]()
        for setGroup in setGroups {
            if let exercise = setGroup.exercise {
                if !result.contains(exercise.muscleGroup) {
                    result.append(exercise.muscleGroup)
                }
            }
        }
        return result
    }
   
    
    public func setGroup(for set: WorkoutSet) -> WorkoutSetGroup? {
        for setGroup in setGroups {
            if setGroup.contains(set: set) { return setGroup }
        }
        return nil
    }
    
    public func setGroupIndex(for set: WorkoutSet) -> Int {
        for setGroup in setGroups {
            if setGroup.contains(set: set) {
                return setGroups.firstIndex(of: setGroup)!
            }
        }
        return 0
    }
    
    public var duration: Int {
        return (sets.map { return $0.duration }).reduce(0, +)
    }
    
    public var type: WorkoutType {
        var occurances = [ExerciseType.core:0, .endurance:0, .legs:0, .pull:0, .push:0]
        for type in (exercises.map { $0.type }) {
            occurances[type]! += 1
        }
        let max = occurances.someKey(forValue: occurances.values.max())
        switch max {
        case .core: return .core
        case .endurance: return .endurance
        case .legs: return .legs
        case .pull: return .pull
        case .push: return .push
        default: return .fullBody
        }
    }
    
}

extension Workout {
    
    static var testWorkouts: [Workout] {
        var workouts = [Workout]()
        for i in 0..<5 {
            var workout = Workout()
            workout.set(name: "Workout"+String(i))
            for i in 0..<5 {
                var exercise = Exercise()
                exercise.muscleGroup = .biceps
                exercise.set(name: "Exercise"+String(i))
                for _ in 0..<Int.random(in: 0..<5) {
                    var set = WorkoutSet()
                    set.exercise = exercise
                    set.repetitions = Int.random(in: 0..<15)
                    set.weight = Float.random(in: 0..<150.0)
                    set.duration = Int.random(in: 0..<30)
                    set.restAfter = Int.random(in: 0..<15)
                    workout.add(set: set)
                }
            }
            workouts.append(workout)
        }
        return workouts
    }
    
}


public enum WorkoutType: String, Identifiable, Equatable, CaseIterable {
    
    public var id: String { rawValue }
    
    case push, pull, legs, fullBody = "full body", core, endurance
    
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value?) -> Key? {
        if val == nil  { return nil }
        return first(where: { $1 == val })?.key
    }
}
