//
//  WorkoutExecutable.swift
//  WorkoutApp
//
//  Created by Lukas Kaibel on 09.02.21.
//

import Foundation

protocol Updatable {
    func update()
}

public class WorkoutExecutable: TimeIteratorDelegate {
    
    ///Variables
    
    public var workout: Workout { didSet { delegate?.update() } }
    public var time: Double = 0.0
    public var restTime: Double = 0.0
    public var isRunning = false { didSet { delegate?.update() } }
    public var isResting = false { didSet { delegate?.update() } }
    private var setPointer: Int = -1, timeIterator = TimeIterator(), timeIntervall = 0.1
    
    var delegate: Updatable?
    
    ///Initialization
    
    public init(workout: Workout) {
        self.workout = workout
        timeIterator.delegate = self
        nextSet() // sets setpointer to 0 
        stop()
        updateTime()
    }
    
    ///Public Methods
    
    public func start() {
        stop()
        timeIterator.start()
        isRunning = true
    }
    
    public func stop() {
        timeIterator.stop()
        isRunning = false
    }
    
    public func end() {
        stop()
        setPointer = workout.sets.count - 1
    }
    
    public func nextSet() {
        stop()
        if !isDone {
            //Sets duration = time, if duration was at 0
            if let set = currentSet, set.duration == 0 {
                currentSet!.duration = Int(time)
            }
            setPointer += 1
            updateTime()
            start()
        }
        delegate?.update()
    }
    
    public func prevSet() {
        if setPointer > 0 {
            setPointer -= 1
            updateTime()
        }
        delegate?.update()
    }
    
    public func jump(toSet index: Int) {
        if index < workout.sets.count {
            setPointer = index
        }
        delegate?.update()
    }
    
    
    func timeChanged() {
        if isRunning {
            if let set = currentSet {
                //checks if set has a set duration, or if it should just use time as stopwatch
                if set.duration > 0 {
                    if time <= 0.0 {
                        stop()
                        nextSet()
                    } else {
                        time -= timeIntervall
                        delegate?.update()
                    }
                } else {
                    time += timeIntervall
                    delegate?.update()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateTime() {
        if let duration = currentSet?.duration {
            if duration > 0 {
                time = Double(duration)
            } else {
                time = 0.0
            }
        }
    }

}


extension WorkoutExecutable {
    
    public var isDone: Bool { return setPointer == workout.sets.count }
    
    public var currentSet: WorkoutSet? {
        get {
            workout.sets.indices.contains(setPointer) ? workout.sets[setPointer] : nil
        }
        set {
            if workout.sets.indices.contains(setPointer) {
                if let set = newValue {
                    workout.replace(set: set)
                    delegate?.update()
                }
            }
        }
    }
    
    public var currentSetGroupIndex: Int? {
        if let currentSet = currentSet {
            for (index, setGroup) in workout.setGroups.enumerated() {
                if setGroup.contains(set: currentSet) {
                    return index
                }
            }
        }
        return nil
    }
    
    public var progressInExercise: Int {
        if let currentSet = currentSet {
            if let setGroup = workout.setGroup(for: currentSet) {
                return setGroup.sets.firstIndex(of: currentSet)!
            }
        }
        return 0
    }
    
}

