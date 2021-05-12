//
//  MainColorGetter.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 21.04.21.
//

import SwiftUI
import simd

 
struct ColorGetterView: View {
    
    @ObservedObject var colorGetter: ColorGetter
    
    var body: some View {
        Text("test")
        VStack {
            ForEach(0..<colorGetter.colors.count, id:\.self) { i in
                colorGetter.colors[i]
                    .frame(width: 100, height: 100)
            }
        }
    }
    
}


class ColorGetter: ObservableObject {
    
    @Published var colors: [Color]
    var delegate: Updatable?
    
    init() {
        colors = [Color]()
        DispatchQueue.global(qos: .userInitiated).async {
            let _colors = getMainColors(of: UIImage(named: "workout")!)
            DispatchQueue.main.async {
                self.colors = _colors
                self.delegate?.update()
            }
        }
    }
    
}


enum GetColorMode {
    case quality, speed
}

func getMainColors(of image: UIImage, numberOfColors: Int = 8, mode: GetColorMode = .speed, noBlacks: Bool = true, noWhites: Bool = true) -> [Color] {
    
    
    guard let cgImage = image.cgImage,
        let data = cgImage.dataProvider?.data,
        let bytes = CFDataGetBytePtr(data) else {
        fatalError("Couldn't access image data")
    }
    assert(cgImage.colorSpace?.model == .rgb)
    
    var pixelData = [SIMD3<Float>]()

    let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
    for y in stride(from: 0, to: cgImage.height, by: mode == .quality ? 10 : 100) {
        for x in stride(from: 0, to: cgImage.width, by: mode == .quality ? 10 : 100) {
            if Double(x-cgImage.width/2)/pow(0.40, 2.0) + Double(y-cgImage.height/2)/pow(0.40, 2.0) <= 1.0 { // makes elliptic selection
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let components = SIMD3(Float(Int(bytes[offset])), Float(Int(bytes[offset + 1])), Float(Int(bytes[offset + 2])))
                pixelData.append(components)
            }
        }
    }
    
    let clusters = kMeans(vectors: pixelData, numberOfCentroids: numberOfColors)
    
    var colors = [Color]()
    var uicolors = [UIColor]()
    for cluster in clusters {
        var x: Float = 0.0
        var y: Float = 0.0
        var z: Float = 0.0
        
        for vector in cluster {
            x += vector[0]
            y += vector[1]
            z += vector[2]
        }
        
        var averageVector = [x/Float(cluster.count), y/Float(cluster.count), z/Float(cluster.count)]
        if noBlacks {
            let shiftValue = Float(80)
            if averageVector[0] < 50 && averageVector[1] < 50 && averageVector[2] < 50 {
                print("too black")
                averageVector[0] += shiftValue
                averageVector[1] += shiftValue
                averageVector[2] += shiftValue
            }
        }
        let uicolor = UIColor(red: CGFloat(averageVector[0])/CGFloat(255.0), green: CGFloat(averageVector[1])/CGFloat(255.0), blue: CGFloat(averageVector[2])/CGFloat(255.0), alpha: 1.0)
        uicolors.append(uicolor)
    }
    
    //uicolors.sort(by: { $0.onGrayScaleFactor() < $1.onGrayScaleFactor() })
    colors = uicolors.map { Color($0) }
    return colors
}


func kMeans(vectors: [SIMD3<Float>], numberOfCentroids: Int, threshold: Float = 10.0) -> [[SIMD3<Float>]] {
    
    //MARK: - Centroid Struct
    struct Centroid {
        var value: SIMD3<Float>
        var vectors: [SIMD3<Float>]
        
        init(value: SIMD3<Float>) {
            self.value = value
            self.vectors = [SIMD3<Float>]()
        }
        
        mutating func updateValue() {
            if !vectors.isEmpty {
                var x: Float = 0.0
                var y: Float = 0.0
                var z: Float = 0.0
                
                for vector in vectors {
                    x += vector[0]
                    y += vector[1]
                    z += vector[2]
                }
                value = SIMD3<Float>(x/Float(vectors.count), y/Float(vectors.count), z/Float(vectors.count))
            }
        }
        
        mutating func clear() {
            vectors = [SIMD3<Float>]()
        }
    }
    //MARK: - Algorithm
    
    //init centroids
    var centroids = [Centroid]()
    for _ in 0..<numberOfCentroids {
        centroids.append(Centroid(value: SIMD3(Float(Int.random(in: 0..<256)), Float(Int.random(in: 0..<256)), Float(Int.random(in: 0..<256)))))
    }
    
    while true {
        for i in centroids.indices {
            centroids[i].clear()
        }
        
        //assigns vectors to nearest centroid
        for vector in vectors {
            var distances = [Int]()
            for centroid in centroids {
                distances.append(Int(distance(vector, centroid.value)))
            }
            let minDistance = distances.smallestElement()
            let centroidIndex = distances.firstIndex(of: minDistance)!
            centroids[centroidIndex].vectors.append(vector)
        }
        
        let oldCentroids = centroids
        
        //update centroid positions
        for i in centroids.indices {
            centroids[i].updateValue()
        }
        var centroidDistanceToOldValues: Float = 0.0
        for i in centroids.indices {
            centroidDistanceToOldValues += distance(centroids[i].value, oldCentroids[i].value)
        }
        
        let averageDistance = centroidDistanceToOldValues/Float(centroids.count)
        if averageDistance < threshold {
            break
        }
    }
    var result = [[SIMD3<Float>]]()
    for centroid in centroids {
        result.append(centroid.vectors)
    }
    return result.sorted(by: { $0.count < $1.count } )
}


extension Array where Element: Comparable {
    
    func smallestElement() -> Element {
        var smallest = self[0]
        for element in self {
            if element < smallest {
                smallest = element
            }
        }
        return smallest
    }
    
}
