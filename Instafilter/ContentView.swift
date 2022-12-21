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
    @State private var filterIntensity = 0.5
    
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var isFilterSheetShowing = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(.secondary)
                    Text("Tap to add new image")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    isShowingImagePicker = true
                }
                
                HStack {
                    Text("intensity")
                        .font(.title3)
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProccessing()}
                }
                HStack {
                    Button("Change Filter") {
                       isFilterSheetShowing = true
                    }
                    Spacer()
                    Button("Save changes", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage()}
            .sheet(isPresented: $isShowingImagePicker) {
                imagePicker(image: $inputImage)
            }
            .confirmationDialog("Select Filter", isPresented: $isFilterSheetShowing) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("X ray") { setFilter(CIFilter.xRay()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    //MARK: Load selected image to filter section
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        
        // pass new image to filter
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        // after loaded image -> modify and return it with new proccessed style to main swift Image
        applyProccessing()
 }
    
    func applyProccessing () {
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            
        }
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
            
        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
            
        }
      
        
         
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
    
    func setFilter (_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
 
    func save() {
        //
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
