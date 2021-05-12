//
//  WorkoutDetail.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.03.21.
//

import SwiftUI


struct WorkoutDetailView: View {
    
    //MARK: Variables
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var workoutList: WorkoutList
    @ObservedObject var workoutExecution: WorkoutExecution
    @ObservedObject var movingGradient: MovingGradient
    @ObservedObject var uiData = userData
    
    @State var performingWorkout = false
    
    //MARK: Body
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(spacing: 40) {
                    uiData.introView(for: workoutExecution.workout)
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(20)
                        .layoutPriority(-1)
                        .shadow(color: .translucentGray, radius: 10, x: 0.0, y: 5.0)
                        .padding(.horizontal, 40)
                    VStack {
                        Text(workoutExecution.workout.name)
                            .font(Font.title2.bold())
                            .foregroundColor(.mutedWhite)
                        HStack {
                            ForEach(workoutExecution.workout.muscleGroups) { muscleGroup in
                                Text(muscleGroup.rawValue.capitalized)
                                    .font(Font.title3.bold())
                                    .foregroundColor(.secondaryMutedWhite)
                            }
                        }
                    }
                    Button(action: {
                        performingWorkout = true
                    }) {
                        HStack {
                            Image.play
                            Text("Start")
                        }.font(Font.body.bold())
                        .foregroundColor(.mutedWhite)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.translucentGray)
                        .cornerRadius(10)
                    }.padding(.horizontal)
                    SetGroupList(workoutEditor: workoutExecution, primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                }.padding(.top, 60)
                VStack {
                    HStack {
                        Spacer()
                        ImageButton(image: Image.xMarkCircle, action: { presentationMode.wrappedValue.dismiss() } )
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding(.horizontal)
                           
                    }
                    Spacer()
                }
            }
        }.background(DarkBlurView(content: uiData.introView(for: workoutExecution.workout, isMuted: true)).scaleEffect(1.2).edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $performingWorkout, content: {
            WorkoutExecutionView(workoutExecution: workoutExecution, workoutList: workoutList, movingGradient: movingGradient)
        })
    }
    
    //MARK: Init
    
    init(workoutList: WorkoutList) {
        self.workoutList = workoutList
        self.workoutExecution = WorkoutExecution(workout: workoutList.selectedWorkout!, workoutColors: userData.workoutColors)
        self.movingGradient = MovingGradient(colors: userData.colors(for: workoutList.selectedWorkout!), timeIntervall: 10.0)
    }
    
}



struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workoutList: WorkoutList())
            
    }
}
