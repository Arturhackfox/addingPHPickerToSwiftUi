//
//  ContentView.swift
//  Instafilter
//
//  Created by Arthur Sh on 17.12.2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

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
    
    
    func loadImage() {
        guard let inputImage = UIImage(named: "example") else { return}
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.bloom()
        currentFilter.inputImage = beginImage
        
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 40, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
      
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
            
        
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
