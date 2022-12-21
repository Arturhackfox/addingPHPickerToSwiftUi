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
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    
    
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
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
                    Text("radius")
                        .font(.title3)
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) { _ in applyProccessing()}
                }
                
                HStack {
                    Text("scale")
                        .font(.title3)
                    Slider(value: $filterScale)
                        .onChange(of: filterScale) { _ in applyProccessing()}
                }
                
                HStack {
                    Button("Change Filter") {
                       isFilterSheetShowing = true
                    }
                    Spacer()
                    Button("Save changes", action: save)
                        .disabled(disableEmptySaving())
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
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("X ray") { setFilter(CIFilter.xRay()) }
                Button("Bokeh blur") { setFilter(CIFilter.bokehBlur()) }
                Button("Circular wrap") { setFilter(CIFilter.circularWrap()) }
                Button("Pointillize") { setFilter(CIFilter.pointillize()) }
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
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops there was an error \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage )
    }
    
    func applyProccessing () {
    
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            
        }
            
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(filterRadius * 400, forKey: kCIInputRadiusKey)

        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
            
        }
        
        if inputKeys.contains(kCIInputAngleKey){
            currentFilter.setValue(filterScale * 115, forKey: kCIInputAngleKey)
            
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    

    
    func setFilter (_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func disableEmptySaving() -> Bool {
        if inputImage == nil {
            return true
        } else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
