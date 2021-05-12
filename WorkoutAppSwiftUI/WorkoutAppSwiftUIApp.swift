//
//  WorkoutAppSwiftUIApp.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 19.02.21.
//

import SwiftUI


var userData = UserData()

@main
struct WorkoutAppSwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            //ColorGetterView(colorGetter: ColorGetter())
            WorkoutListView(workoutList: WorkoutList())
            //VideoPickerView(sourceType: .photoLibrary, onVideoPicked: { url in  print(url.path) })
        }
    }
}
