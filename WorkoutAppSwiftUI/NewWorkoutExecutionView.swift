//
//  NewWorkoutExecutionView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 09.06.21.
//

import SwiftUI

struct NewWorkoutExecutionView: View {
    
    //MARK: Variables
    
    @ObservedObject var executor: WorkoutExecution
    
    @State var showingMediaPlayer: Bool = false
    
    //MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            if showingMediaPlayer {
                MediaPlayer()
                    .padding()
                    .transition(.move(edge: .top))
            }
            video
                .overlay (
                    ZStack {
                        if !executor.isRunning {
                            Color.translucentGray
                            Image.play
                                .foregroundColor(.white)
                                .font(.system(size: 60))
                        }
                        workoutStatsOverlay
                    }
                )
                .onTapGesture {
                    executor.startStop()
                }
                .gesture (
                    DragGesture()
                        .onChanged { drag in
                            if drag.translation.height > 50 {
                                showingMediaPlayer = true
                            } else if drag.translation.height < -50 {
                                showingMediaPlayer = false
                            }
                        }
                )
                .cornerRadius(executor.isRunning ? 0 : 20)
                .padding(executor.isRunning ? 0 : 20)
            if executor.isRunning {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(executor.workout.sets) { set in
                            HStack(spacing: 14) {
                                Text("\(executor.workout.sets.firstIndex(of: set)!+1)")
                                    .foregroundColor(.secondaryLabel)
                                    .fontWeight(.medium)
                                SetExecutionCell(set: set)
                            }.padding(.horizontal)
                            .padding(.vertical, 35)
                            Divider()
                            if set.restAfter > 0 {
                                HStack {
                                    Text("Rest")
                                    Spacer()
                                    TimeView(time: Double(set.restAfter), showMiliseconds: false)
                                }
                                .font(.body.monospacedDigit().weight(.semibold))
                                .padding()
                                .background(Color.secondaryBackground)
                                Divider()
                            }
                        }
                        createdBy
                            .padding(.vertical, 50)
                    }
                }
            }
            Spacer(minLength: 0)
        }.animation(.interactiveSpring())
    }
    
    var video: some View {
        Image("workout")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    var workoutStatsOverlay: some View {
        VStack {
            HStack {
                TimeView(time: executor.time, showMiliseconds: false)
                Spacer()
                repsAndWeight
            }.foregroundColor(.white)
            .font(.title2.monospacedDigit().weight(.medium))
            .padding()
            Spacer()
        }
    }
    
    var repsAndWeight: some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            if executor.currentSet.repetitions > 0 {
                Text(String(executor.currentSet.repetitions))
                Image.multiply
                    .font(.body.bold())
            }
            if executor.currentSet.weight > 0.0 {
                Text(String(format: "%.1f", (executor.currentSet.weight)))
                Text("kg")
            }
        }
    }
    
    var createdBy: some View {
        VStack(spacing: 15) {
            Text(executor.workout.name)
                .font(.body.weight(.semibold))
            Text("by")
                .foregroundColor(.secondaryLabel)
                .font(.caption.weight(.semibold))
            HStack {
                Image("workout2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle(), style: FillStyle())
                Text("Athlean X")
                    .foregroundColor(.secondaryLabel)
                    .font(.caption.weight(.medium))
            }
        }
    }
    
}


struct SetExecutionCell: View {
    
    let set: WorkoutSet
    
    var body: some View {
        HStack {
            Text(set.exercise.name.capitalized)
            Spacer()
            HStack {
                repsAndWeight
                Divider()
                if set.duration > 0 {
                    TimeView(time: Double(set.duration), showMiliseconds: false)
                }
            }
        }.font(.body.bold().monospacedDigit())
    }
    
    var repsAndWeight: some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            if set.repetitions > 0 {
                Text(String(set.repetitions))
                Image.multiply
                    .font(.caption.bold())
            }
            if set.weight > 0.0 {
                Text(String(format: "%.1f", (set.weight)))
                Text("kg")
            }
        }
    }
    
}


import MediaPlayer

struct MediaPlayer: View {
    
    //MARK: Variables
    
    @State var playPauseImage: Image = MPMusicPlayerController.systemMusicPlayer.playbackState == .playing ? .pause : .play
    @State var title: String = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem?.title ?? "Not Playing"
    @State var artist: String = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem?.artist ?? ""
    @State var cover: UIImage? = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 200, height: 200))
    
    let player = MPMusicPlayerController.systemMusicPlayer
    
    //MARK: Body
    
    var body: some View {
        HStack(spacing: 15) {
            Group {
                if let cover = cover {
                    Image(uiImage: cover)
                        .resizable()
                } else {
                    Image("workout2")
                        .resizable()
                }
            }.frame(width: 60, height: 60)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(5)
            VStack {
                Text(title)
                Text(artist)
                    .foregroundColor(.secondaryLabel)
            }.font(.body.weight(.medium))
            Spacer()
            ImageButton(image: playPauseImage, action: {
                player.playbackState == .playing ? player.pause() : player.play()
                update()
            }).foregroundColor(.black)
            .frame(width: 20, height: 20)
            ImageButton(image: .forward, action: {
                player.skipToNextItem()
                update()
            }).foregroundColor(.black)
            .frame(width: 30, height: 30)
        }.padding()
        .background(Color.secondaryBackground)
        .cornerRadius(20)
    }
    
    private func update() {
        title = player.nowPlayingItem?.title ?? "Not Playing"
        artist = player.nowPlayingItem?.artist ?? ""
        playPauseImage = player.playbackState == .playing ? .pause : .play
    }
    
}


struct NewWorkoutExecutionView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutExecutionView(executor: WorkoutExecution(workout: Workout.testWorkouts[0]))
    }
}
