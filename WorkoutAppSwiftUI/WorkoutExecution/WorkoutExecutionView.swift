//
//  WorkoutExecutionView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 03.03.21.
//

import SwiftUI

struct WorkoutExecutionView: View {
    
    @ObservedObject var workoutExecution: WorkoutExecution
    @ObservedObject var workoutList: WorkoutList
    @ObservedObject var movingGradient: MovingGradient
    
    @State var showingDetail = true
    @State var showingMediaPlayer = false
    @State var setSelected = false
    @State var isAdding = false
    
    var body: some View {
        GeometryReader { geoemtry in
            ZStack {
                VStack {
                    
                    Text(workoutExecution.workout.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.mutedWhite)
                        .padding()

                    
                    Group {
                        if showingDetail {
                            SetDetail(workoutExecution: workoutExecution)
                        } else {
                            GeometryReader { geometry in
                                ScrollView {
                                    SetGroupList(workoutEditor: workoutExecution, primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                                }
                                    .mask(
                                    VStack(spacing: 0) {
                                        Rectangle()
                                        LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .center, endPoint: .bottom)
                                        .frame(maxHeight: 30)
                                    }
                                )
                            }
                        }
                    }
                    
                    
                    WorkoutFlowControllView(workoutExecution: workoutExecution, showingDetail: $showingDetail, showingMediaPlayer: $showingMediaPlayer, isAdding: $isAdding)
                        .padding(.top)
                        .frame(height: geoemtry.size.height * 1/3)
                    
                    
                }
                
                if showingMediaPlayer {
                    SmallPopoverBlur(isPresented: $showingMediaPlayer, content: MusicPlayer())
                }
 
                //Set Editor View (edits Attributes of Set)
                if setSelected {
                    AttributeEditingView(isPresented: $setSelected, editor: workoutExecution)
                        .background(VisualEffectView(effect: UIBlurEffect(style: .regular)))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .background(DarkBlurView(content: movingGradient.view).scaleEffect(1.2).edgesIgnoringSafeArea(.all))
        .popover(isPresented: $isAdding, content: {
            AddExerciseView(isPresented: $isAdding, exerciseAdder: ExerciseAdder(workoutEditor: workoutExecution))
        })
    }
    
    //MARK: - Graphic Constants
    
    
    
}


struct SelectableSymbolButton: View {
    
    let symbol: Image
    var color: Color = .blue
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            GeometryReader { geometry in
                ZStack {
                    if isSelected {
                        color
                            .cornerRadius(10)
                            .inverseMask(
                                symbol
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width - 10, height: geometry.size.height - 10)
                                    .padding()
                            )
                           
                    } else {
                        Color.clear
                            .padding()
                            .cornerRadius(10)
                        symbol
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(color)
                            .frame(width: geometry.size.width - 10, height: geometry.size.height - 10)
                    }
                }.font(Font.body.bold())
            }
        })
    }
    
    
}

extension View {
    // view.inverseMask(_:)
    public func inverseMask<M: View>(_ mask: M) -> some View {
        // exchange foreground and background
        let inversed = mask
            .foregroundColor(.black)  // hide foreground
            .background(Color.white)  // let the background stand out
            .compositingGroup()       // ⭐️ composite all layers
            .luminanceToAlpha()       // ⭐️ turn luminance into alpha (opacity)
        return self.mask(inversed)
    }
}

struct WorkoutFlowControllView: View {
    
    @ObservedObject var workoutExecution: WorkoutExecution
    @Binding var showingDetail: Bool
    @Binding var showingMediaPlayer: Bool
    @Binding var isAdding: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                VStack {
                    
                    SegmentedProgressBar(progress: workoutExecution.progressInExercise, progressInCurrentSegment: workoutExecution.progressInSet, maximum: workoutExecution.setsInCurrentSetGroup, accentColor: .mutedWhite, backgroundColor: .secondaryMutedWhite)
                    
                    if workoutExecution.currentSet.duration > 0 {
                        HStack(spacing: 0) {
                            TimeView(time: Double(workoutExecution.currentSet.duration) - workoutExecution.time, showMiliseconds: false)
                            Spacer()
                            Text("-")
                            TimeView(time: workoutExecution.time, showMiliseconds: false)
                        }.font(Font.subheadline.monospacedDigit())
                        .foregroundColor(.secondaryMutedWhite)
                    }
                }
                .padding(.horizontal)
                HStack(spacing: 70) {
                    ImageButton(image: Image.backward, action: {
                        workoutExecution.backward()
                    }).frame(width: 40, height: 40)
                    ImageButton(image: startStopButtonImage) {
                        workoutExecution.startStop()
                    }.frame(width: 40, height: 40)
                    ImageButton(image: Image.forward, action: {
                        workoutExecution.forward()
                    }).frame(width: 40, height: 40)
                }.foregroundColor(.mutedWhite)
               
                Spacer()
                HStack(spacing: 70) {
                    SelectableSymbolButton(symbol: .plus, color: .mutedWhite, isSelected: isAdding) {
                        isAdding.toggle()
                    }.frame(width: 30, height: 30)
                    SelectableSymbolButton(symbol: .note, color: .mutedWhite, isSelected: showingMediaPlayer) {
                        showingMediaPlayer.toggle()
                    }.frame(width: 30, height: 30)
                    SelectableSymbolButton(symbol: Image.list,color: .mutedWhite, isSelected: !showingDetail) {
                        showingDetail.toggle()
                    }
                    .frame(width: 30, height: 30)
                }.foregroundColor(.mutedWhite)
                Spacer()
            }
            
        }
    }
    
    // MARK: - Graphical Variables
    
    private var startStopButtonImage: Image { return workoutExecution.isRunning ? Image.pause : Image.play }
    
}


struct DarkBlurView<Content: View>: View {
    
    let content: Content
    
    var body: some View {
        ZStack {
            content
                .blur(radius: 50)
            Color.translucentGray
        }
    }
    
}

struct WorkoutExecutionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutExecutionView(workoutExecution: WorkoutExecution(workout: Workout.testWorkouts[0]), workoutList: WorkoutList(), movingGradient: MovingGradient(colors: [.blue, .lightGreen], timeIntervall: 10.0))
            .preferredColorScheme(.dark)
    }
}



