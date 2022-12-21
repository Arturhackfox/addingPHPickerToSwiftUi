//
//  PHPicker.swift
//  Instafilter
//
//  Created by Arthur Sh on 17.12.2022.
//

import SwiftUI
import PhotosUI

struct imagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    //Coordinator talks between these two worlds "uiKit" and "SwiftUI "
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: imagePicker
        
        init(_ parent: imagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
        
    }
    
// MARK: lifehack -> typealias UIViewControllerType = PHPickerViewController
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // <- Coorinator class handles communication between viewController and swift ui BRIDGE
    }
    
}
