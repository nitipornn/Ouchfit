import SwiftUI

struct PlannerView: View {
    @StateObject private var weatherManager = WeatherManager()
    @State private var currentDate = Date()  // Selected date from the calendar
    @State private var selectedImages: [UIImage] = []  // Array to store selected images from wardrobe
    @State private var canvasImages: [UIImage] = []  // Images added to the canvas
    @State private var dateImages: [Date: [UIImage]] = [:]  // Store images by date

    @State private var isImagePickerPresented = false  // Flag to show image picker
    @State private var isCanvasPresented = false  // Flag to show canvas for creating image

    @ObservedObject var wardrobeViewModel: WardrobeViewModel  // Pass wardrobeViewModel

    var body: some View {
        VStack {
            Text("Planner")
                .font(.custom("Bristol", size: 30))
            Text("Weather on \(currentDate, formatter: dateFormatter):")
                .font(.custom("Classyvogueregular", size: 23))
            Text(weatherManager.weatherData)
                .font(.custom("Classyvogueregular", size: 18))
            // DatePicker to select a date
            DatePicker("Select a Date", selection: $currentDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())

            // Show the saved images for the selected date
            if let images = dateImages[currentDate] {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                    }
                }
            }


            
            // Button to create canvas for drawing or selecting an image
            Button("Create Canvas") {
                isCanvasPresented.toggle()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.custom("Classyvogueregular", size: 17))
        }
        .onAppear {
            fetchWeather()  // Fetch weather data when the view appears
            loadSavedData() // Load saved data when the view appears
        }
        .onChange(of: currentDate) { _ in
            fetchWeather()  // Fetch weather data when a new date is selected
            clearCanvas()  // Clear canvas when switching to a new date
        }
        .edgesIgnoringSafeArea(.top)
        .fullScreenCover(isPresented: $isImagePickerPresented) {
            // Show the wardrobe items in a list for image selection
            ImagePickerView(selectedImages: $selectedImages, isImagePickerPresented: $isImagePickerPresented, wardrobeViewModel: wardrobeViewModel)
        }
        .fullScreenCover(isPresented: $isCanvasPresented) {
            // Pass the selected images to CanvasView for manipulation
            CanvasView(selectedImages: $selectedImages, canvasImages: $canvasImages, isCanvasPresented: $isCanvasPresented, currentDate: $currentDate, dateImages: $dateImages)
        }
    }

    // Function to save canvas images
    func saveCanvasImages() {
        // Filter out any images that were deleted from the canvas
        dateImages[currentDate] = canvasImages
        saveData()  // Save data to UserDefaults
    }

    // Function to clear the canvas
    func clearCanvas() {
        selectedImages.removeAll()
        canvasImages.removeAll()
    }

    // Fetch weather data
    func fetchWeather() {
        let lat = 13.7563  // Latitude for Bangkok
        let lon = 100.5018 // Longitude for Bangkok
        weatherManager.fetchWeather(lat: lat, lon: lon)  // Fetch weather data
    }

    // Load saved data from UserDefaults
    func loadSavedData() {
        if let savedImages = UserDefaults.standard.object(forKey: "savedImages") as? Data,
           let images = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedImages) as? [UIImage] {
            canvasImages = images
        }
    }

    // Save data to UserDefaults
    func saveData() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: canvasImages, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: "savedImages")
        }
    }

    // DateFormatter for displaying date in the calendar
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}







// ImagePicker to allow user to select multiple images from the wardrobe


struct ImagePickerView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var isImagePickerPresented: Bool
    @ObservedObject var wardrobeViewModel: WardrobeViewModel

    var body: some View {
        VStack {
            // Display wardrobe items in a list
            List(wardrobeViewModel.wardrobeItems) { item in
                HStack {
                    // Display each image from the wardrobe
                    if let uiImage = UIImage(data: Data(base64Encoded: item.imageURL) ?? Data()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                selectedImages.append(uiImage)  // Add selected image
                                isImagePickerPresented = false  // Close the picker and return to canvas
                            }
                    }
                }
            }

            Button("Back to Canvas") {
                isImagePickerPresented = false  // Close the picker
            }
            .font(.custom("Classyvogueregular", size: 20))
            .padding()
        }
    }
}


import SwiftUI

struct CanvasView: View {
    @Binding var selectedImages: [UIImage]  // Images selected for the canvas
    @Binding var canvasImages: [UIImage]  // Images that are saved in the canvas
    @Binding var isCanvasPresented: Bool  // To dismiss canvas view
    @Binding var currentDate: Date  // Current selected date
    @Binding var dateImages: [Date: [UIImage]]  // Store images by date

    @State private var imagePositions: [Int: CGPoint] = [:]  // Track positions of each image
    @State private var isImagePickerPresented = false  // Flag to show image picker

    var body: some View {
        VStack {
            ZStack {
                // Display the selected images from the wardrobe on canvas
                ForEach(selectedImages.indices, id: \.self) { index in
                    Image(uiImage: selectedImages[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .position(imagePositions[index, default: CGPoint(x: 150, y: 150)]) // Default position
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    imagePositions[index] = value.location // Update position while dragging
                                }
                                .onEnded { _ in
                                    canvasImages.append(selectedImages[index]) // Save image to canvas when dragging is complete
                                }
                        )
                        .gesture(
                            LongPressGesture(minimumDuration: 1.0) // Detect long press
                                .onEnded { _ in
                                    // Remove the image from the canvas if long pressed
                                    selectedImages.remove(at: index)
                                    imagePositions.removeValue(forKey: index)  // Remove its position
                                }
                        )
                }
            }


            // Button to select image from the wardrobe
            Button("Select Image") {
                isImagePickerPresented.toggle()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(.custom("Classyvogueregular", size: 20))

            // Button to confirm and save the canvas image
            Button("Confirm Image") {
                saveCanvasImages()
                isCanvasPresented = false
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(.custom("Classyvogueregular", size: 20))
        }
        .padding()
        .background(Color.white)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isImagePickerPresented) {
            // Show the wardrobe items in a list for image selection
            ImagePickerView(selectedImages: $selectedImages, isImagePickerPresented: $isImagePickerPresented, wardrobeViewModel: WardrobeViewModel())
        }
    }

    // Function to save canvas images
    func saveCanvasImages() {
        // Filter out any images that were deleted from the canvas
        dateImages[currentDate] = canvasImages
        saveData()  // Save data to UserDefaults
    }

    // Function to clear the canvas
    func clearCanvas() {
        selectedImages.removeAll()
        canvasImages.removeAll()
    }

    // Save data to UserDefaults
    func saveData() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: canvasImages, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: "savedImages")
        }
    }
}




struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView(wardrobeViewModel: WardrobeViewModel())  // Pass the wardrobeViewModel
    }
}
