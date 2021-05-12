//
//  WorkoutExecution.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 03.03.21.
//

import SwiftUI

class WorkoutExecution: WorkoutEditor, Updatable {
    
    @Published private var workoutExecutable: WorkoutExecutable
    @Published private var workoutColors: [Workout:[Color]] = [Workout:[Color]]()
        
    init(workout: Workout, workoutColors: [Workout:[Color]]) {
        workoutExecutable = WorkoutExecutable(workout: workout)
        self.workoutColors = workoutColors
        super.init(workout: workout)
        workoutExecutable.delegate = self
    }
    
    override init(workout: Workout) {
        workoutExecutable = WorkoutExecutable(workout: workout)
        super.init(workout: workout)
        workoutExecutable.delegate = self
    }
    // MARK: - Access to the Model
    
    override var workout: Workout { get { workoutExecutable.workout } set { workoutExecutable.workout = newValue; objectWillChange.send() } }
    //BAD CODE !!!!!!!!!!!!!!!!!!!!!!!!!!
    var currentSet: WorkoutSet { get { workoutExecutable.currentSet != nil ? workoutExecutable.currentSet! : WorkoutSet() } set { workoutExecutable.currentSet = newValue } }
    var time: Double { get { workoutExecutable.time } set { workoutExecutable.time = newValue } }
    var progressInSet: Double { if currentSet.duration > 0 { return 1 - time / Double(currentSet.duration) } else { return 1.0 } }
    var isRunning: Bool { return workoutExecutable.isRunning }
    var progressInExercise: Int { return workoutExecutable.progressInExercise + 1}
    var setsInCurrentSetGroup: Int {
        if let index = workoutExecutable.currentSetGroupIndex {
            return workout.setGroups[index].count
        } else {
            return 0
        }
    }
    var setGroups: [WorkoutSetGroup] { workoutExecutable.workout.setGroups }
    var currentSetGroupIndex: Int? { workoutExecutable.currentSetGroupIndex }
    
    var currentSetString: String { workoutExecutable.currentSet?.exercise.name ?? "" }
    
    func update() {
        objectWillChange.send()
    }
    
    // MARK: - Intend
        
    func start() {
        workoutExecutable.start()
    }
    
    func startStop() {
        if workoutExecutable.isRunning { workoutExecutable.stop() }
        else { workoutExecutable.start() }
    }
    
    func forward() {
        workoutExecutable.nextSet()
        workoutExecutable.stop()
        workoutExecutable.start()
    }
    
    func backward() {
        workoutExecutable.prevSet()
    }
   
    //MARK: Private Methods
    
    func colors(for workout: Workout) -> [Color] {
        if let colors = workoutColors[workout] {
            return colors
        } else {
            return [.lightGreen, .blue]
        }
    }
    
}
