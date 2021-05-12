//
//  VideoPicker.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.05.21.
//

import SwiftUI

public struct VideoPickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onVideoPicked: (URL) -> Void
    private let maxClipLength: Int
    @Environment(\.presentationMode) private var presentationMode

    public init(sourceType: UIImagePickerController.SourceType, onVideoPicked: @escaping (URL) -> Void, maxClipLength: Int = 5) {
        self.sourceType = sourceType
        self.onVideoPicked = onVideoPicked
        self.maxClipLength = maxClipLength
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = TimeInterval(maxClipLength)
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onVideoPicked: self.onVideoPicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onVideoPicked: (URL) -> Void

        init(onDismiss: @escaping () -> Void, onVideoPicked: @escaping (URL) -> Void) {
            self.onDismiss = onDismiss
            self.onVideoPicked = onVideoPicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

            if let url = info[.mediaURL] as? URL {
                self.onVideoPicked(url)
            }
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

    }

}

struct VideoPicker_Previews: PreviewProvider {
    static var previews: some View {
        VideoPickerView(sourceType: .photoLibrary, onVideoPicked: { url in })
    }
}
