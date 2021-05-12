//
//  WorkoutExecutionEditor.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 14.04.21.
//

import SwiftUI

class WorkoutExecutionEditor: WorkoutEditor, Updatable {
    
    //MARK: Variables
    
    @Binding var bindingWorkout: Workout
    
    override var workout: Workout {
        get {
            return bindingWorkout
        }
        set {
            bindingWorkout = newValue
        }
    }
    
    //MARK: Initialization
    
    init(workout: Binding<Workout>, delegate: Updatable? = nil) {
        self._bindingWorkout = workout
        super.init()
    }
    
    //MARK: Public Methods
    
    func update() {
        objectWillChange.send()
    }
    
}
