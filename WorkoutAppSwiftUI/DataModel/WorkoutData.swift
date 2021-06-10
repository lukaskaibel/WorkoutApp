//
//  WorkoutData.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 12.05.21.
//

import SwiftUI

struct WorkoutData {
    
    var image: Image?
    var intro: URL?
    var outro: URL?
    var exerciseData: [Exercise:ExerciseData]
    
    init(image: Image? = nil, intro: URL? = nil, outro: URL? = nil, exerciseData: [Exercise:ExerciseData] = [Exercise:ExerciseData]()) {
        self.image = image
        self.intro = intro
        self.outro = outro
        self.exerciseData = exerciseData
    }
    
    mutating func add(data: ExerciseData, for exercise: Exercise) {
        exerciseData[exercise] = data
    }
    
    mutating func removeData(for exercise: Exercise) {
        exerciseData.removeValue(forKey: exercise)
    }
    
}
