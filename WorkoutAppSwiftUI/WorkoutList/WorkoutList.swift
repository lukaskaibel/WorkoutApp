//
//  WorkoutList.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.03.21.
//

import SwiftUI

class WorkoutList: ObservableObject {
    
    // MARK: Variables
    
    @Published private(set) var workouts: [Workout] = Workout.testWorkouts
    @Published var searchedText: String = "" 
        
    lazy var selectedWorkout: Workout? = workouts[0] //clean up lazy unnecessary
    
    
    init() {
        
    }
    
    // MARK: Public Methods
    
    var filteredWorkouts: [Workout] {
        workouts.filter { searchedText.isEmpty ? true : $0.name.lowercased().contains(searchedText.lowercased()) }
    }
    
    func add(workout: Workout, with image: UIImage? = nil) {
        workouts.append(workout)
        if let image = image {
            userData.workoutImages[workout] = Image(uiImage: image)
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    userData.workoutColors[workout] = getMainColors(of: image, numberOfColors: 3)
                }
            }
        }
    }
    
    func remove(workout: Workout) {
        workouts = workouts.filter { $0 != workout }
    }

    
}
