//
//  ExerciseAdder.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 29.04.21.
//

import SwiftUI


class ExerciseAdder: ObservableObject {
    
    //MARK: Stored Variables
    
    @Published var selectedExercises: [Exercise] = [Exercise]()
    @Published var filterMuscleGroup: MuscleGroup?
    @Published var searchedText: String = ""
    
    var workoutEditor: WorkoutEditor
    
    //MARK: Initialization
    
    init(workoutEditor: WorkoutEditor) {
        self.workoutEditor = workoutEditor
    }
    
    var allExercises: [Exercise] { Exercise.all() }
    
    var filteredExercises: [Exercise] {
        (allExercises.filter { filterMuscleGroup == nil ? true : filterMuscleGroup == $0.muscleGroup } ).filter { searchedText.isEmpty ? true : $0.name.contains(searchedText.lowercased()) }
    }
    
    func addSelected() {
        workoutEditor.workout.add(setGroups: selectedExercises.map { WorkoutSetGroup($0) }, at: workoutEditor.workout.setGroups.count)
        selectedExercises = [Exercise]()
    }
    
    
    func add(selection: Exercise) {
        if selectedExercises.isEmpty {
            selectedExercises = [selection]
        } else if !selectedExercises.contains(selection) {
            selectedExercises.append(selection)
        }
    }
    
    func remove(selection: Exercise) {
        selectedExercises = selectedExercises.filter { $0 != selection }
    }
    
    func exerciseSelected(_ exercise: Exercise) -> Bool {
        return selectedExercises.contains(exercise)
    }
    
    
    func tappedFilter(with muscleGroup: MuscleGroup) {
        filterMuscleGroup = muscleGroup
    }
}
