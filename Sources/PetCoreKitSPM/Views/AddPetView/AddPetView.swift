//
//  AddPetView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import SQAUtility
import Shared_kit 

struct AddPetView: View {
    
    @EnvironmentObject private var petVM: PetCoreViewModel
    
    @State private var currentStep: Int = 0
    
    @State private var petAge: Int = 0
    @State private var petWeight: Double = 0.0
    @State private var petDescription: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker: Bool = false
    
    private let totalSteps: Int = 4
    private let stepTitles: [String] = [
        "Basic Info",
        "Pet Details",
        "Health Info",
        "Review"
    ]
    
    var body: some View {
         VStack(spacing: 0) {
                // Stepper Header
                stepperHeader
                
                // Content Area
                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                    }
                    .padding()
                }
                
                // Navigation Buttons
                navigationButtons
        }
         .toolbar(content: {
             ToolbarItem(placement: .principal) {
                 Text("Add New Pet")
             }
         })
        .onAppear {
            Task {
                try await petVM.fetchPetType()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    // MARK: - Stepper Header
    private var stepperHeader: some View {
        VStack(spacing: 16) {
            // Progress Bar
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    Rectangle()
                        .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .padding(.horizontal)
            
            // Step Indicators
            HStack {
                ForEach(0..<totalSteps, id: \.self) { step in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text("\(step + 1)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(step <= currentStep ? .white : .gray)
                            )
                        
                        Text(stepTitles[step])
                            .font(.caption2)
                            .foregroundColor(step <= currentStep ? .blue : .gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    if step < totalSteps - 1 {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Step Content
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            step1BasicInfo
        case 1:
            step2PetDetails
        case 2:
            step3HealthInfo
        case 3:
            step4Review
        default:
            EmptyView()
        }
    }
    
    // MARK: - Step 1: Basic Info
    private var step1BasicInfo: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Let's start with the basics")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pet Name")
                    .font(.headline)
                
                SQATextField(placeholder: "Enter your pet's name", text: $petVM.petName)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pet Type")
                    .font(.headline)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
//                    ForEach(PetCoreDeveloperPreview.shared.previewAnimalType, id: \.self) { petType in
                    ForEach(petVM.petTypeList, id: \.self) { petType in
                        PetTypeCardComponent(
                            petType: petType,
                            isSelected: petVM.petType == petType.type ?? "",
                            onTap: {
                                petVM.setPetType(petType.type?.uppercased() ?? "")
                            }
                        )
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 2: Pet Details
    private var step2PetDetails: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tell us more about your pet")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Breed")
                    .font(.headline)
                
                TextField("Enter breed", text: $petVM.petBreed)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Age (years)")
                    .font(.headline)
                
                Stepper(value: $petAge, in: 0...30) {
                    Text("\(petAge) years old")
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pet Photo")
                    .font(.headline)
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera")
                                        .font(.title2)
                                    Text("Add Photo")
                                        .font(.caption)
                                }
                                .foregroundColor(.gray)
                            )
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 3: Health Info
    private var step3HealthInfo: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Health information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Weight (kg)")
                    .font(.headline)
                
                HStack {
                    TextField("0.0", value: $petWeight, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    Text("kg")
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Additional Notes")
                    .font(.headline)
                
                TextEditor(text: $petDescription)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 4: Review
    private var step4Review: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Review your pet's information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(spacing: 12) {
                    reviewRow(title: "Name", value: petVM.petName ?? "")
                    reviewRow(title: "Type", value: petVM.petType)
                    reviewRow(title: "Breed", value: petVM.petBreed)
                    reviewRow(title: "Age", value: "\(petAge) years")

                    
                    if !petDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notes:")
                                .font(.headline)
                            Text(petDescription)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private func reviewRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button("Previous") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            Spacer()
            
            if currentStep < totalSteps - 1 {
                Button("Next") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
//                .disabled(!canProceedToNextStep)
            } else {
                Button("Save Pet") {
                    savePet()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!isFormComplete)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
    
    // MARK: - Helper Properties
    private var canProceedToNextStep: Bool {
        switch currentStep {
        case 0:
            return petVM.petName.isEmpty && petVM.petType.isEmpty
        case 1:
            return !petVM.petBreed.isEmpty
        case 2:
            return petWeight > 0
        default:
            return true
        }
    }
    
    private var isFormComplete: Bool {
        return petVM.petName.isEmpty && !petVM.petType.isEmpty && !petVM.petBreed.isEmpty && petWeight > 0
    }
    
    // MARK: - Actions
    private func savePet() {
        // Implement your save logic here
        print("Saving pet: \(petVM.petName)")
        // You can add navigation back or show success message
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    AddPetView()
        .withPetCorePreviewDependecies()
}

