//
//  ContentView.swift
//  Instafilter
//
//  Created by Arthur Sh on 17.12.2022.
//

import SwiftUI


struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var isSheetShowing = false
    var body: some View {
        VStack {
          image?
                .resizable()
                .scaledToFit()
            
            Button("add image") {
                isSheetShowing = true
            }
            
            Button("Save image") {
                guard let inputImage = inputImage else { return }
                    let imageSaver = ImageSaver()
                
                imageSaver.writeToPhotoAlbum(image: inputImage)
                }
            }
        .onChange(of: inputImage, perform: { _ in convertImages()})
        .sheet(isPresented: $isSheetShowing) {
            imagePicker(image: $inputImage)
        }

    }
    
    func convertImages() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
