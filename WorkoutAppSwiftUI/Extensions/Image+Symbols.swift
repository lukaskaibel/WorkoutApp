//
//  Image+Symbols.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.03.21.
//

import SwiftUI
import AVKit


extension Image {
    
    static var play: Image { Image(systemName: "play.fill") }
    static var playCircle: Image { Image(systemName: "play.circle.fill") }
    static var pause: Image { Image(systemName: "pause.fill") }
    static var forward: Image { Image(systemName: "forward.fill") }
    static var backward: Image { Image(systemName: "backward.fill") }
    static var multiply: Image { Image(systemName: "multiply") }
    static var weight: Image { Image(systemName: "scalemass.fill") }
    static var stopwatch: Image { Image(systemName: "stopwatch.fill") }
    static var hourglass: Image { Image(systemName: "hourglass") }
    static var list: Image { Image(systemName: "list.bullet") }
    static var plus: Image { Image(systemName: "plus") }
    static var plusCircle: Image { Image(systemName: "plus.circle") }
    static var plusCircleFill: Image { Image(systemName: "plus.circle.fill") }
    static var chevronUp: Image { Image(systemName: "chevron.up") }
    static var chevronDown: Image { Image(systemName: "chevron.down") }
    static var pencil: Image { Image(systemName: "pencil") }
    static var exercise: Image { Image("squat") }
    static var exerciseWhite: Image { Image("squatWhite") }
    static var xMarkCircle: Image { Image(systemName: "xmark.circle.fill") }
    static var note: Image { Image(systemName: "music.note") }
    static var edit: Image { Image(systemName: "pencil") }
    
    static var video: Image { Image(systemName: "video.fill") }
    static var videoCircle: Image { Image(systemName: "video.circle.fill") }
    static var cameraCircle: Image { Image(systemName: "camera.circle.fill") }

    static var dots: Image { Image(systemName: "ellipsis") }
    
    static var circle: Image { Image(systemName: "circle") }
    static var checkmarkCircle: Image { Image(systemName: "checkmark.circle.fill") }
    static var star: Image { Image(systemName: "star") }
    static var starFill: Image { Image(systemName: "star.fill") }

    static var pushup: Image {Image("pushup") }
    static var pullup: Image { Image("pullup") }
    static var squat: Image { Image("squat") }
    static var crunch: Image { Image("crunch") }
    static var running: Image { Image("running") }
    static var fullBody: Image { Image("person") }
    
    static func symbol(for attribute: SetAttribute) -> Image {
        switch attribute {
        case .repetitions: return .multiply
        case .duration: return .stopwatch
        case .weight: return .weight
        case .restAfter: return .hourglass
        }
    }
    
}


extension Image {
    
    static func imageFromVideo(url: URL, at time: TimeInterval) -> Image? {
        let asset = AVURLAsset(url: url)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return Image(uiImage: UIImage(cgImage: thumbnailImageRef))
    }
    
}
