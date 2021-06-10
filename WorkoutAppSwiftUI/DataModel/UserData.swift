//
//  UIData.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 30.04.21.
//

import SwiftUI
import Firebase


class UserData: ObservableObject, RawRepresentable, Codable {
    
    //MARK: Variables
    
    @Published var favoriteExercises: [Exercise] = [Exercise]()
    @Published var workoutColors: [Workout:[Color]] = [Workout:[Color]]()
    @Published private(set) var workoutData: [Workout:WorkoutData] = [Workout:WorkoutData]()
    @Published var exerciseVideos: [Exercise:URL] = [Exercise:URL]()

    //MARK: Public Methods
    
    //WorkoutData Methods
    
    func add(image: UIImage, for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.image = Image(uiImage: image)
        } else {
            workoutData[workout] = WorkoutData(image: Image(uiImage: image))
        }
        
        //Firebase Upload
        Storage.uploadImage(image: image, to: "\(workout.id)/image")
    }
    
    func removeImage(for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.image = nil
        }
    }
    
    func add(intro: URL, for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.intro = intro
        } else {
            workoutData[workout] = WorkoutData(intro: intro)
        }
        
        //Firebase upload
        Storage.uploadVideo(url: intro, to: "\(workout.id)/intro")
    }
    
    func removeIntro(for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.intro = nil
        }
    }
    
    func add(outro: URL, for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.outro = outro
        } else {
            workoutData[workout] = WorkoutData(outro: outro)
        }
        
        //Firebase upload
        Storage.uploadVideo(url: outro, to: "\(workout.id)/outro")
    }
    
    func removeOutro(for workout: Workout) {
        if workoutData[workout] != nil {
            workoutData[workout]!.outro = nil
        }
    }
    
    //Exercise Video Methods
    
    func add(videoURL: URL, for exercise: Exercise) {
        exerciseVideos[exercise] = videoURL
    }
    
    //Favorites Methods

    func favoriteTapped(for exercise: Exercise) {
        if favoriteExercises.contains(exercise) {
            favoriteExercises = favoriteExercises.filter { $0 != exercise }
        } else {
            favoriteExercises.append(exercise)
        }
    }
    
    
    @ViewBuilder
    func thumbnail(for workout: Workout) -> some View {
        //Workout has stored Image
        if let image = workoutData[workout]?.image {
            image
                .resizable()
        }
        //Workout does'nt have stored Image -> Generate Gradient View With Symbol
        else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.lightGreen, .blue]), startPoint: .topTrailing, endPoint: .bottom)
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                            HStack {
                                Spacer()
                                self.symbol(for: workout)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height * 2/3)
                                    .opacity(0.2)
                                Spacer()
                            }
                        Spacer()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func introView(for workout: Workout, isMuted: Bool = false) -> some View {
        if let url = workoutData[workout]?.intro {
            LoopingPlayer(url: url, isMuted: isMuted)
        } else {
            thumbnail(for: workout)
        }
    }
    
    func symbol(for workout: Workout) -> Image {
        switch workout.type {
        case .push: return .pushup
        case .pull: return .pullup
        case .endurance: return .running
        case .legs: return .squat
        case .core: return .crunch
        default: return .fullBody
        }
    }
    
    
    func colors(for workout: Workout) -> [Color] {
        if let colors = workoutColors[workout] {
            return colors
        } else {
            return [.lightGreen, .blue]
        }
    }
    
    
    //MARK: Init & Storing Mechanism
    
    init() {
        
    }
    
    required init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(UserData.self, from: data)
        else {
            return nil
        }
        self.favoriteExercises = result.favoriteExercises
    }

    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
}


extension Storage {
    
    static func uploadImage(image: UIImage, to path: String) {
        let uploadReference = Storage.storage().reference(withPath: path)
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        uploadReference.putData(imageData, metadata: uploadMetaData, completion: { (downloadMetaData, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            } else {
                print("Upload worked: \(String(describing: downloadMetaData))")
            }
        })
    }
    
    static func uploadVideo(url: URL, to path: String) {
        let storageReference = Storage.storage().reference(withPath: path)
        
        if let videoData = try? Data(contentsOf: url) {
            let metaData = StorageMetadata()
            metaData.contentType = "video/quicktime"
                    
            // Start the video storage process
            storageReference.putData(videoData, metadata: metaData, completion: { (metadata, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Successful Video Upload !")
                }
            })
        } else {
            print("Video URL invalid")
        }
    }
    
    static func deleteFile(at path: String) {
        let storageReference = Storage.storage().reference(withPath: path)
        storageReference.delete { error in
            if let error = error {
                print("Firebase deletion failed: \(error.localizedDescription)")
            } else {
                print("Successful Firebase deletion !")
            }
        }
    }
    
}
