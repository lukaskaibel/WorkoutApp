//
//  MusicPlayer.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 13.04.21.
//

import SwiftUI
import MediaPlayer

struct MusicPlayer: View {
    
    @State var playPauseImage: Image = MPMusicPlayerController.systemMusicPlayer.playbackState == .playing ? .pause : .play
    @State var title: String = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem?.title ?? "Not Playing"
    @State var artist: String = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem?.artist ?? ""
    
    let player = MPMusicPlayerController.systemMusicPlayer
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 5) {
                Text(title)
                    .lineLimit(1)
                    .font(Font.title3.bold())
                    .foregroundColor(.mutedWhite)
                Text(artist)
                    .font(Font.body)
                    .foregroundColor(.secondaryMutedWhite)
            }
            HStack(spacing: 50) {
                ImageButton(image: .backward, action: {
                    player.skipToPreviousItem()
                    update()
                }).frame(width: 35, height: 35)
                ImageButton(image: playPauseImage, action: {
                    player.playbackState == .playing ? player.pause() : player.play()
                    update()
                }).frame(width: 35, height: 35)
                ImageButton(image: .forward, action: {
                    player.skipToNextItem()
                    update()
                }).frame(width: 35, height: 35)
            }.foregroundColor(.mutedWhite)
        }.frame(width: 300)
        .animation(.none)
        .padding(.vertical, 40)
        .background(Color.translucentDarkGray)

    }
    
    private func update() {
        title = player.nowPlayingItem?.title ?? "Not Playing"
        artist = player.nowPlayingItem?.artist ?? ""
        playPauseImage = player.playbackState == .playing ? .pause : .play
    }
    
}

struct MusicPlayer_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer()
            .padding()
            .background(Color.darkGray)
            .cornerRadius(20)
    }
}
