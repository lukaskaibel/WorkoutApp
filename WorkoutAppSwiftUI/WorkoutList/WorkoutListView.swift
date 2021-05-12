//
//  ContentView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 19.02.21.
//

import SwiftUI


struct WorkoutListView: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutList: WorkoutList
    
    @State var showingWorkout = false
    @State var showingNewWorkout = false
    @State var isSearchingInWorkouts = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    LazyVStack {
                        SearchBar(text: $workoutList.searchedText, placeholder: "Search in Workouts", isEditing: $isSearchingInWorkouts)
                            .padding(.vertical)
                            .padding(.horizontal, 10)
                        if workoutList.searchedText.isEmpty {
                            Section(header: Header(text: "Recent Workouts").font(Font.title2.bold())) {
                                ScrollView(.horizontal) {
                                    LazyHStack {
                                        Spacer(minLength: 15)
                                            .frame(height: 230)
                                        ForEach(workoutList.workouts) { workout in
                                            WorkoutCellView(workoutList: workoutList, workout: workout)
                                                .frame(width: (geometry.size.width - 50) / 2)
                                                .onTapGesture {
                                                    workoutList.selectedWorkout = workout
                                                    showingWorkout = true
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        Section(header: Header(text: "All Workouts").font(Font.title2.bold())) {
                            LazyVStack {
                                ForEach(workoutList.filteredWorkouts) { workout in
                                    HWorkoutCellView(workoutList: workoutList, workout: workout)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            workoutList.selectedWorkout = workout
                                            showingWorkout = true
                                        }
                                    Divider()
                                        .padding(.leading, 120)
                                }
                            }
                        }.padding(.top)
                    }
                }.navigationBarTitle("My Workouts")
                .navigationBarItems(trailing: Button(action: { showingNewWorkout = true }) {
                    Image.plus
                })
            }.navigationViewStyle(StackNavigationViewStyle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .fullScreenCover(isPresented: $showingWorkout, content: {
            WorkoutDetailView(workoutList: workoutList)
        })
        .popover(isPresented: $showingNewWorkout, content: {
            EditWorkoutView(isPresented: $showingNewWorkout, workoutList: workoutList, workoutEditor: WorkoutEditor())
        })
    }
    
    
    private struct Header: View {
        
        let text: String
        
        var body: some View {
            HStack {
                Text(text)
                Spacer()
            }.padding(.horizontal)
        }
        
    }
    
}


struct WorkoutCellView: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutList: WorkoutList
    @ObservedObject var uiData = userData
    
    var workout: Workout
    
    //MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            uiData.thumbnail(for: workout)
                .frame(height: 160)
                .aspectRatio(contentMode: .fill)
                
            VStack {
                Text(workout.name)
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(.mutedWhite)
                HStack {
                    if workout.muscleGroups.isEmpty {
                        Text("")
                    } else {
                        ForEach(workout.muscleGroups) { muscleGroup in
                            Text(muscleGroup.rawValue.capitalized)
                        }.font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.secondaryMutedWhite)
                    }
                }
            }.padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    uiData.thumbnail(for: workout)
                    VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
                }
            )
            .clipped()
        }.cornerRadius(20.0)
        .clipped()
    }
}


struct HWorkoutCellView: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutList: WorkoutList
    @ObservedObject var uiData = userData
    
    let workout: Workout
    
    var body: some View {
        HStack {
            uiData.thumbnail(for: workout)
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
                .cornerRadius(10.0)
            VStack(alignment: .leading) {
                Text(workout.name)
                    .foregroundColor(.label)
                    .fontWeight(.semibold)
                HStack {
                    if workout.muscleGroups.isEmpty {
                        Text("")
                    } else {
                        ForEach(workout.muscleGroups) { muscleGroup in
                            Text(muscleGroup.rawValue.capitalized)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondaryLabel)
                        }
                    }
                }
            }
            Spacer()
        }.contentShape(Rectangle())
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView(workoutList: WorkoutList())
            .preferredColorScheme(.light)
    }
}
