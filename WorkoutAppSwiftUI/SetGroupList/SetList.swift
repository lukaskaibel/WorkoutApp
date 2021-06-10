//
//  SetList.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 12.05.21.
//

import SwiftUI

struct SetList: View {
    
    @ObservedObject var workoutEditor: WorkoutEditor
    
    var body: some View {
        LazyVStack {
            ForEach(workoutEditor.selectedSetGroup!.sets) { set in
                VStack(spacing: 5) {
                    SetView(workoutEditor: workoutEditor, set: set)
                        .padding(.vertical, 10)
                    if workoutEditor.selectedSetIndex >= 0, set == workoutEditor.selectedSet {
                        AttributeEditingView(isPresented: $workoutEditor.setSelected, editor: workoutEditor)
                            .foregroundColor(.mutedWhite)
                    }
                }
            }
        }
    }
    
}


struct SetView: View {
    
    @ObservedObject var workoutEditor: WorkoutEditor
    
    let set: WorkoutSet
    
    var body: some View {
        HStack {
            ValueWithUnitView(value: String(set.repetitions), unit: "rps", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .repetitions ? Color.secondaryMutedWhite : .clear)
                .clipShape(Capsule())
                .onTapGesture {
                    workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                    workoutEditor.selectedAttribute = .repetitions
                }
            Rectangle()
                .frame(width: 3, height: 25)
                .cornerRadius(2.0)
                .foregroundColor(.secondaryMutedWhite)
            ValueWithUnitView(value: String(set.duration), unit: "s", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .duration ? Color.secondaryMutedWhite : .clear)
                .clipShape(Capsule())
                .onTapGesture {
                    workoutEditor.selectedAttribute = .duration
                    workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                }
            Rectangle()
                .frame(width: 3, height: 25)
                .cornerRadius(2.0)
                .foregroundColor(.secondaryMutedWhite)
            ValueWithUnitView(value: String(Int(set.weight)), unit: "kg", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .weight ? Color.secondaryMutedWhite : .clear)
                .clipShape(Capsule())
                .onTapGesture {
                    workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                    workoutEditor.selectedAttribute = .weight
                }
            Rectangle()
                .frame(width: 3, height: 25)
                .cornerRadius(2.0)
                .foregroundColor(.secondaryMutedWhite)
            ValueWithUnitView(value: String(set.restAfter), unit: "s", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .restAfter ? Color.secondaryMutedWhite : .clear)
                .clipShape(Capsule())
                .onTapGesture {
                    workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                    workoutEditor.selectedAttribute = .restAfter
                }
        }
    }
}


struct SetList_Previews: PreviewProvider {
    static var previews: some View {
        SetList(workoutEditor: WorkoutEditor(workout: Workout.testWorkouts[0]))
    }
}
