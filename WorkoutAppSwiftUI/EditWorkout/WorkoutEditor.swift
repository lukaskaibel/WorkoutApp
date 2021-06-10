//
//  WorkoutEditor.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 17.03.21.
//

import SwiftUI


class WorkoutEditor: ObservableObject {
    
    //MARK: Variables
    
    @Published var workout: Workout
    @Published var image: UIImage?
   
    @Published var selectedSetGroupIndex: Int = -1   
    @Published var selectedSetIndex: Int = -1
    @Published var selectedAttribute: SetAttribute = .repetitions
    
    var setGroupSelected: Bool {
        get { return workout.setGroups.indices.contains(selectedSetGroupIndex) }
        set { if !newValue { selectedSetGroupIndex = -1 } }
    }
    var setSelected: Bool {
        get { return workout.sets.indices.contains(selectedSetIndex) }
        set { if !newValue { selectedSetIndex = -1 } }
    }
    var isExecuting: Bool { type(of: self) == WorkoutExecutionEditor.self }
    
    
    init() {
        workout = Workout()
    }
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    // MARK: - Access to Model
    
    //DONT use unless selectedSetIndex >= 0, will crash otherwise
    var selectedSet: WorkoutSet {
        get {
            return workout.sets[selectedSetIndex]
        }
        set {
            workout.replace(set: newValue)
        }
    }
    
    var selectedSetGroup: WorkoutSetGroup? {
        get { workout.setGroups.indices.contains(selectedSetGroupIndex) ? workout.setGroups[selectedSetGroupIndex] : nil }
        set { if let setGroup = newValue { workout.replace(setGroup: setGroup) } }
    }
    
    var weight: [Int] {
        get { [weightWholeValue, weightDecimalValue] }
        set { weightWholeValue = newValue[0]; weightDecimalValue = newValue[1] }
    }
    
    var weightWholeValue: Int {
        get { Int(selectedSet.weight) }
        set { selectedSet.weight = Float(newValue) + selectedSet.weight.truncatingRemainder(dividingBy: 1.0) }
    }
    
    var weightDecimalValue: Int {
        get { Int(selectedSet.weight.truncatingRemainder(dividingBy: 1.0) * 8.0) }
        set { selectedSet.weight = Float(Int(selectedSet.weight)) + Float(newValue)/8.0 }
    }
    
    // MARK: - Public Methods
    
    func add(set: WorkoutSet) {
        workout.add(set: set)
    }
    
    func replace(set: WorkoutSet) {
        workout.replace(set: set)
    }
    
    func removeSet(for setGroup: WorkoutSetGroup, at index: Int) {
        if setGroup.sets.indices.contains(index) {
            workout.remove(set: setGroup.sets[index])
        }
    }
    
    func removeSetGroup(_ setGroup: WorkoutSetGroup) {
        if let index = workout.setGroups.firstIndex(of: setGroup) {
            removeSetGroup(at: index)
        }
    }
    
    func removeSetGroup(at index: Int) {
        workout.remove(setGroup: workout.setGroups[index])
        if index == selectedSetGroupIndex { selectedSetGroupIndex = -1 }
    }
    
    func removeSetGroups(at indexSet: IndexSet) {
        for index in indexSet {
            workout.remove(setGroup: workout.setGroups[index])
            if index == selectedSetGroupIndex { selectedSetGroupIndex = -1 }
        }
    }
    
    func addSet(for setGroup: WorkoutSetGroup) {
        if let lastSetInSetGroup = setGroup.sets.last {
            let set = lastSetInSetGroup.duplicate()
            workout.add(set: set, for: setGroup)
        } else {
            workout.add(set: WorkoutSet(), for: setGroup)
        }
        objectWillChange.send()
    }
    
    func addSet() {
        var set = WorkoutSet()
        set.duration = 10
        workout.add(set: set)
    }
    
    func add(image: UIImage) {
        self.image = image
    }
    
    
}


