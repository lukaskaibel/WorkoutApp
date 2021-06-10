//
//  Exercise.swift
//  WorkoutApp
//
//  Created by Lukas Kaibel on 09.02.21.
//

import Foundation

public struct Exercise: Identifiable, Codable {
    
    ///Variables
    
    public var id: Int
    private(set) var name: String
    var muscleGroup: MuscleGroup
    
    ///Public Methods
    
    public init() {
        id = IDFactory.getUnique()
        name = "New Exercise"
        muscleGroup = .none
    }
    
    public mutating func set(name: String) {
        if !name.isEmpty { self.name = name }
    }

    
    static func all() -> [Exercise] {
        if let url = Bundle.main.url(forResource: "clean_data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let exercises = try decoder.decode([Exercise].self, from: data)
                return exercises
            } catch {
                print("error:\(error)")
            }
        }
        return [Exercise]()
    }

    
    func muscleGroup(for name: String) -> MuscleGroup {
        switch name {
        case "abdominals": return .abdominals
        case "adductors": return .adductors
        case "quadriceps": return .quadriceps
        case "biceps": return .biceps
        case "shoulders": return .shoulders
        case "chest": return .chest
        case "hamstrings": return .hamstrings
        case "middle back": return .middleBack
        case "calves": return .calves
        case "glutes": return .glutes
        case "lower back": return .lowerBack
        case "lats": return .lats
        case "triceps": return .triceps
        case "traps": return .traps
        case "stationar": return .stationar
        case "forearms": return .forearms
        case "neck": return .neck
        case "abductors": return .abductors
        case "treadmil": return .treadmil
        default: return.none
        }
    }
    
    public var type: ExerciseType {
        switch muscleGroup {
        case .abdominals, .stationar: return .core
        case .adductors, .quadriceps, .hamstrings, .calves, .abductors, .glutes: return .legs
        case .shoulders, .chest, .triceps: return .push
        case .biceps, .middleBack, .lowerBack, .traps, .forearms, .lats, .neck: return .pull
        default: return .endurance
        }
    }
    
}

extension Exercise: Equatable, Hashable {
    
    public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    
}


public enum MuscleGroup: String, Codable, Identifiable, Equatable, CaseIterable {
    
    public var id: String { rawValue }
    
    case abdominals, adductors, quadriceps, biceps, shoulders, chest, hamstrings, middleBack = "middle back", calves, glutes, lowerBack = "lower back", lats, triceps, traps, stationar, forearms, neck, abductors, treadmil, none = ""
    
    public static func == (lhs: MuscleGroup, rhs: MuscleGroup) -> Bool {
        return lhs.id == rhs.id
    }
    
}


public enum ExerciseType: String {
    
    public var id: String { rawValue }
    
    case push, pull, legs, core, endurance
}
