//
//  EditWorkoutView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 11.03.21.
//

import SwiftUI
import AVKit


struct EditWorkoutView: View {
    
    //MARK: Variables
        
    @Binding var isPresented: Bool
    
    @ObservedObject var workoutList: WorkoutList
    @StateObject var workoutEditor: WorkoutEditor
    @StateObject var uiData: UserData = userData
    
    @State var dragOver: Bool = false
    @State var isAdding: Bool = false
    @State var addingImage: Bool = false
    @State var addingIntro: Bool = false
    @State var addingOutro: Bool = false
    
    @State var test = true
    
    //MARK: Body
    
   
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    NavigationLink(destination: SetGroupDetailView(workoutEditor: workoutEditor), isActive: $workoutEditor.setGroupSelected, label: { EmptyView() })
                    LazyVStack(spacing: 0) {
                        Spacer(minLength: 20)
                        Section(header: header, footer: footer) {
                            Button(action: { isAdding = true }) {
                                HStack {
                                    Image.plusCircleFill
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.green)
                                    Text("Add Exercises")
                                        .foregroundColor(.label)
                                    Spacer()
                                }.padding()
                            }
                            Divider()
                                .padding(.leading, 50)
                            SetGroupList(workoutEditor: workoutEditor, onTapOfSetGroup: { setGroup in
                                workoutEditor.selectedSetGroupIndex = workoutEditor.workout.setGroups.firstIndex(of: setGroup)!
                            })
                        }
                        Spacer(minLength: 100)
                    }
                }
                .navigationBarItems(leading: Button("Cancel", action: { isPresented = false })
                    , trailing: Button(action: {
                    if let image = workoutEditor.image {
                        workoutList.add(workout: workoutEditor.workout, with: image)
                    } else {
                        workoutList.add(workout: workoutEditor.workout)
                    }
                    isPresented = false
                }) {
                    Text("Save")
                        .fontWeight(.semibold)
                }
                )
                .navigationBarTitle("", displayMode: .inline)
                .onAppear {
                    UINavigationBar.appearance().barTintColor = .systemBackground
                    UINavigationBar.appearance().scrollEdgeAppearance?.shadowColor = .white
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            
        }.popover(isPresented: $isAdding, content: {
            AddExerciseView(isPresented: $isAdding, exerciseAdder: ExerciseAdder(workoutEditor: workoutEditor))
        })
        //Apples Image Picker View
        .fullScreenCover(isPresented: $addingImage, content: {
            ImagePickerView(sourceType: .photoLibrary, onImagePicked: { image in
                workoutEditor.add(image: image)
            })
        })
        //Apples Video Picker View
        .fullScreenCover(isPresented: $addingIntro, content: {
            VideoPickerView(sourceType: .photoLibrary, onVideoPicked: { url in
                uiData.add(intro: url, for: workoutEditor.workout)
            }, maxClipLength: Constant.maxIntroClipLength)
        })
        .fullScreenCover(isPresented: $addingOutro, content: {
            VideoPickerView(sourceType: .photoLibrary, onVideoPicked: { url in
                uiData.add(intro: url, for: workoutEditor.workout)
            }, maxClipLength: Constant.maxOutroClipLength)
        })
    }
    
    //MARK: Supporting Views
    
    private var header: some View {
            VStack {
                HStack {
                    Spacer()
                    editibleImage
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: 300)
                        .cornerRadius(20.0)
                        .shadow(color: .translucentGray, radius: 10, x: 0.0, y: 5.0)
                        .onTapGesture {
                            addingImage = true
                        }
                    Spacer()
                }.padding(.horizontal)
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        TextField("Workout Name", text: $workoutEditor.workout.name)
                            .font(Font.title3.bold())
                            .multilineTextAlignment(.center)
                            
                        HStack {
                            ForEach(workoutEditor.workout.muscleGroups) { muscleGroup in
                                Text(muscleGroup.rawValue.capitalized)
                            }.font(Font.body.bold())
                            .foregroundColor(.secondaryLabel)
                        }
                    }
                    Spacer()
                }.padding(.vertical)
                HStack {
                    introView
                        .frame(width: 120, height: 80)
                        .cornerRadius(10.0)
                    VStack(alignment: .leading) {
                        Text("Intro")
                            .font(.caption.bold())
                        Text("Plays before the workout starts.")
                            .font(.caption2)
                            .foregroundColor(.secondaryLabel)
                    }
                    Spacer()
                }.padding(.horizontal)
                .onTapGesture {
                    addingIntro = true
                }
                Divider()
                    .padding(.leading)
                }
    }
    
    
    private var footer: some View {
        VStack {
            Divider()
                .padding(.leading)
            HStack {
                outroView
                    .frame(width: 120, height: 80)
                    .cornerRadius(10.0)
                VStack(alignment: .leading) {
                    Text("Outro")
                        .font(.caption.bold())
                    Text("Plays when the workout is finished.")
                        .font(.caption2)
                        .foregroundColor(.secondaryLabel)
                }
                Spacer()
            }.padding(.horizontal)
            .onTapGesture {
                addingOutro = true
            }
        }
    }
    
    @ViewBuilder
    private var editibleImage: some View {
        GeometryReader { geometry in
            if let image = workoutEditor.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .layoutPriority(-1)
                    Color.white.opacity(0.0001)
                }
            } else {
                ZStack {
                    Color.secondaryBackground
                    Image.cameraCircle
                        .resizable()
                        .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/5)
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
    }
    
    @ViewBuilder
    var introView: some View {
        if let url = uiData.workoutData[workoutEditor.workout]?.intro {
            LoopingPlayer(url: url, isMuted: true)
        } else {
            Rectangle()
                .foregroundColor(.secondaryBackground)
                .overlay(Image.videoCircle.foregroundColor(.gray).font(.title))
        }
    }
    
    @ViewBuilder
    var outroView: some View {
        if let url = uiData.workoutData[workoutEditor.workout]?.outro {
            LoopingPlayer(url: url, isMuted: true)
        } else {
            Rectangle()
                .foregroundColor(.secondaryBackground)
                .overlay(Image.videoCircle.foregroundColor(.gray).font(.title))
        }
    }
    
    
}


struct EditWorkoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditWorkoutView(isPresented: .constant(true), workoutList: WorkoutList(), workoutEditor: WorkoutEditor(workout: Workout.testWorkouts[0]))
    }
    
}
