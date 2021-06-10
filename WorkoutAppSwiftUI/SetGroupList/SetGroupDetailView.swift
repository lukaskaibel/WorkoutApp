//
//  SetGroupDetailView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 12.05.21.
//

import SwiftUI

struct SetGroupDetailView: View {
    
    @ObservedObject var workoutEditor: WorkoutEditor
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text(workoutEditor.selectedSetGroup?.exercise?.name ?? "Pushup")
                    Text(workoutEditor.selectedSetGroup?.muscleGroup?.rawValue.capitalized ?? "Chest")
                        .font(.footnote)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(10.0)
            .padding()
        }
    }
}

struct SetGroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SetGroupDetailView(workoutEditor: WorkoutEditor(workout: Workout.testWorkouts[0]))
    }
}
