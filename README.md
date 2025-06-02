# PetCoreKitSPM

## Overview
PetCoreKitSPM is a comprehensive Swift Package Manager module that provides complete core functionality for a sophisticated pet management system. This professionally architected module is designed for seamless integration into iOS applications, offering robust features for pet data management, user profiles, a multi-step pet creation wizard, and modern UI components following contemporary iOS design patterns and best practices.

## Author
**Danis Preldzic**

## Requirements
- **iOS**: 17.0+
- **Swift**: 6.0+
- **Xcode**: 15.0+
- **Swift Package Manager**: Supported

## Dependencies

### External Dependencies
- **[Factory](https://github.com/hmlongco/Factory)** (2.4.5): Advanced Swift dependency injection framework for clean architecture and testability

### Local Dependencies
- **SQAUtility**: Local dependency providing storage management, utilities, and coordinator protocols
- **SQAServices**: Local dependency for network services, API communication, and backend integration
- **Shared_kit**: Local dependency for shared UI components, breed management, and common utilities

## Key Features

### 🐾 Complete Pet Management System
- **Full CRUD Operations**: Create, read, update, and delete pet profiles with comprehensive data validation
- **Multi-step Pet Creation Wizard**: Professionally designed 5-step guided process:
  - **Step 1**: Basic Information (Name, Pet Type selection)
  - **Step 2**: Breed Selection (Dynamic breed fetching based on pet type)
  - **Step 3**: Pet Details (Weight, Description, Physical characteristics)
  - **Step 4**: Health Information (Birthday, Adoption date with date validation)
  - **Step 5**: Review & Confirmation (Final review with image preview)
- **Advanced Pet Profiles**: Detailed pet information management with image handling
- **Pet Type Support**: Dogs, Cats, Birds, Reptiles, Small Mammals with extensible architecture
- **Dynamic Breed Integration**: Real-time breed fetching and caching based on selected pet type
- **Lost Pet Tracking**: Built-in lost pet status management and tracking capabilities

### 👤 User Management & Authentication
- **Secure User Profile Management**: Complete user information retrieval and management
- **User-Pet Relationships**: Advanced mapping and management of pets owned by specific users
- **Token-based Authentication**: Secure authentication with encrypted storage integration
- **Caretaker Management**: Support for multiple caretakers per pet

### 🎨 Advanced UI Components & Design
- **Modern Dashboard**: Interactive overview with customizable pet cards and real-time updates
- **Comprehensive Pet Profiles**: Full-featured pet information display with editing capabilities
- **Professional Image Management**: Integrated image upload, editing, and optimization
- **Intuitive Navigation**: Step-by-step forms with progress indicators and validation feedback
- **Responsive Design**: Adaptive UI supporting multiple screen sizes and orientations
- **Accessibility Support**: Full VoiceOver and accessibility feature integration

### 🏗️ Enterprise Architecture & Design Patterns
- **MVVM Architecture**: Clean separation of concerns with testable business logic
- **Coordinator Pattern**: Centralized navigation management with dependency injection
- **Factory-based Dependency Injection**: Advanced DI for enhanced testability and modularity
- **Protocol-Oriented Design**: Abstracted data access layers with mock support
- **Modern SwiftUI Patterns**: Advanced usage of @StateObject, @Published, @EnvironmentObject
- **Async/Await Concurrency**: Modern Swift concurrency for optimal performance

## Installation

### Swift Package Manager (Recommended)

#### Option 1: Xcode Integration
1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies**
3. Enter the repository URL: `https://github.com/username/PetCoreKitSPM`
4. Select version `1.0.0` or later
5. Add to your target

#### Option 2: Package.swift Integration
Add PetCoreKitSPM to your Swift Package dependencies:

```swift
// Package.swift
let package: Package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [
        .package(url: "https://github.com/username/PetCoreKitSPM", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                "PetCoreKitSPM"
            ]
        )
    ]
)
```

## Complete Project Architecture

### 📁 Project Structure

### Models
- **PetModel**: Comprehensive pet information including:
  - Basic info: name, breed, type, gender, size
  - Health data: weight, birthday, adoption date
  - Metadata: owner ID, description, image
  - Lost pet tracking capabilities
- **UserModel**: Complete user profile with authentication data
- **PetTypeModel**: Pet type definitions with associated images
- **ImageModel**: Image handling and metadata
- **ResponseModel<T>**: Generic API response wrapper

### ViewModels
- **PetCoreViewModel**: Central business logic coordinator featuring:
  - Pet CRUD operations
  - Multi-step form state management
  - Image selection and upload handling
  - Date formatting and age calculations
  - Validation logic for form completion
  - Alert and loading state management

### Coordinators
- **PetCoreCoordinator**: Navigation flow manager with:
  - SwiftUI NavigationStack integration
  - Route-based navigation system
  - Sheet presentation management
  - Dependency injection coordination

### Views

#### Main Views
- **PetCoreRootView**: Main navigation container
- **DashboardView**: Pet overview with interactive cards
- **AddPetView**: Multi-step pet creation wizard
- **PetProfileView**: Detailed pet information and editing

#### Add Pet Wizard Steps
- **Step1BasicInfo**: Name and pet type selection
- **Step2PetBreed**: Dynamic breed selection
- **Step3PetDetails**: Physical characteristics
- **Step4HealthInfo**: Health and date information
- **Step5Review**: Final review and confirmation

#### Reusable Components
- **ActivePetCardViewComponent**: Interactive pet dashboard cards
- **PetTypeCardComponent**: Pet type selection cards
- **ImagePickerComponent**: Image selection interface

### DataSource Architecture

#### Protocol Layer
- **PetCoreDataSourceProtocol**: Complete API interface defining:
  - `func addPet(pet: PetModel) async throws -> ResponseModel<PetModel>`
  - `func fetchOwnerPets(ownerID: String) async throws -> ResponseModel<[PetModel]>`
  - `func fetchPetById(petID: String) async throws -> ResponseModel<PetModel>`
  - `func fetchUserById(userID: String) async throws -> ResponseModel<UserModel>`
  - `func fetchPetType() async throws -> ResponseModel<[PetTypeModel]>`
  - `func editPet(pet: PetModel) async throws -> ResponseModel<PetModel>`
  - `func deletePet(petID: String) async throws -> ResponseModel<String>`

#### Implementation Layer
- **PetCoreDataSourceImplementation**: Production API implementation with:
  - RESTful API communication
  - Secure authentication headers
  - Comprehensive error handling
  - Type-safe network operations

### API Endpoints
- **POST** `/pets` - Create new pet
- **GET** `/pets/owner/{ownerID}` - Fetch user's pets
- **GET** `/pets/{petID}` - Fetch specific pet
- **PUT** `/pets/{petID}` - Update pet information
- **DELETE** `/pets/{petID}` - Delete pet
- **GET** `/user/{userID}` - Fetch user information
- **GET** `/pets/animals/types` - Fetch available pet types

### Helpers
- **PetCoreAPIPaths**: Centralized API path management
- **PetCoreDeveloperPreviewHelper**: Development and testing utilities

## Usage

### Basic Initialization
```swift
import PetCoreKitSPM
import SwiftUI

struct ContentView: View {
    var body: some View {
        PetCoreKitSPM.start { 
            print("PetCoreKit initialized successfully")
        }
    }
}
```

### Accessing Pet Data with Dependency Injection
```swift
import PetCoreKitSPM
import SwiftUI
import Factory

class PetManager: ObservableObject {
    @Injected(\PetCoreKitSPM.petCoreDataSource) var petCoreDataSource: PetCoreDataSourceProtocol
    
    func fetchUserPets(ownerID: String) async {
        do {
            let response: ResponseModel<[PetModel]> = try await petCoreDataSource.fetchOwnerPets(ownerID: ownerID)
            if let pets: [PetModel] = response.data {
                // Handle successful pet fetching
                print("Fetched \(pets.count) pets")
            }
        } catch {
            print("Error fetching pets: \(error)")
        }
    }
    
    func createNewPet(pet: PetModel) async {
        do {
            let response: ResponseModel<PetModel> = try await petCoreDataSource.addPet(pet: pet)
            if let createdPet: PetModel = response.data {
                print("Pet created successfully: \(createdPet.name ?? "Unknown")")
            }
        } catch {
            print("Error creating pet: \(error)")
        }
    }
}
```

### Using the Pet Creation Wizard
```swift
import PetCoreKitSPM
import SwiftUI

struct MyPetCreationView: View {
    var body: some View {
        NavigationView {
            PetCoreKitSPM.start { 
                // Navigate to the add pet flow
                PetCoreCoordinator.shared.navigate(to: .createPet)
            }
        }
    }
}
```

### Working with Pet View Model
```swift
import PetCoreKitSPM
import SwiftUI

class PetViewController: ObservableObject {
    let petViewModel: PetCoreViewModel = PetCoreViewModel()
    
    func setupNewPet() {
        // Configure pet creation form
        petViewModel.petName = "Buddy"
        petViewModel.setPetType("DOG")
        petViewModel.setPetBreed("Golden Retriever", breedID: "golden-retriever-id")
        petViewModel.setPetGender("MALE")
        petViewModel.setPetSize("LARGE")
        petViewModel.petWeight = "30.5"
        petViewModel.petDescription = "Friendly and energetic dog"
    }
    
    func validatePetForm() -> Bool {
        return petViewModel.isFormComplete
    }
}
```

### Custom Pet Profile Integration
```swift
import PetCoreKitSPM
import SwiftUI

struct CustomPetProfileView: View {
    @StateObject private var petViewModel: PetCoreViewModel = PetCoreViewModel()
    let petID: String
    
    var body: some View {
        VStack {
            if let pet: PetModel = petViewModel.selectedPet {
                Text(pet.name ?? "Unknown Pet")
                    .font(.title)
                
                if let age: String = petViewModel.calculateAge(from: pet.dateOfBirth ?? "") {
                    Text("Age: \(age)")
                        .font(.subtitle)
                }
                
                Text("Breed: \(pet.breedName ?? "Unknown")")
                    .font(.body)
            }
        }
        .task {
            await loadPetData()
        }
    }
    
    private func loadPetData() async {
        do {
            let response: ResponseModel<PetModel> = try await petViewModel.petCoreDataSource.fetchPetById(petID: petID)
            if let pet: PetModel = response.data {
                petViewModel.setSelectedPet(pet)
            }
        } catch {
            print("Error loading pet: \(error)")
        }
    }
}
```

## Architecture

PetCoreKitSPM follows modern iOS architecture patterns:

### MVVM + Coordinator Pattern
1. **Models**: Define data structures and business entities
2. **Views**: Handle UI presentation and user interactions
3. **ViewModels**: Manage business logic, state, and data transformation
4. **Coordinators**: Handle navigation flow and dependency management

### Dependency Injection with Factory
The module uses Factory for clean dependency injection:
- Singleton data source instances
- Protocol-based abstractions
- Testable architecture
- Clean separation of concerns

### Data Flow
```
UI Layer (SwiftUI Views)
    ↓ User Interactions
ViewModel Layer (Business Logic)
    ↓ Data Requests
Coordinator Layer (Navigation & DI)
    ↓ Service Calls
DataSource Layer (API Abstraction)
    ↓ Network Requests
SQAServices (Network Implementation)
    ↓ HTTP/REST
Backend API (Server)
```

## Testing
The package includes comprehensive testing capabilities:
- Unit tests for view models
- Protocol mocking for data sources
- Preview helpers for UI components
- Developer preview data for testing

## Development Features
- **Preview Support**: Complete SwiftUI preview implementations
- **Mock Data**: Rich developer preview helpers with sample data
- **Error Handling**: Comprehensive error management throughout the stack
- **Loading States**: Built-in loading and alert state management
- **Type Safety**: Full type safety with Codable models and generic responses

## Performance Considerations
- **Async/Await**: Modern concurrency for network operations
- **Lazy Loading**: Efficient data loading strategies
- **Memory Management**: Proper @StateObject and @ObservableObject usage
- **Network Optimization**: Efficient API calls with proper error handling

## License
Proprietary - All rights reserved

### 🔧 Core Models

#### PetModel
```swift
public struct PetModel: Identifiable, Codable, Sendable {
    public var id: String?
    var ownerID: String?
    var name: String?
    var breedID: String?
    var breedName: String?
    var dateOfBirth: String?
    var adoptionDate: String?
    var gender: String?
    var isLost: Bool?
    var size: String?
    var petType: String?
    var weightValue: String?
    var description: String?
    var image: ImageModel?
    var weight: Double?
    var caretakers: [String]
    
    // Complete initializer with default values
    public init(
        id: String? = nil,
        ownerID: String = "",
        name: String = "",
        breedID: String = "",
        breedName: String = "",
        dateOfBirth: String = "",
        adoptionDate: String = "",
        gender: String = "",
        isLost: Bool = false,
        size: String = "",
        petType: String = "",
        weightValue: String = "",
        description: String = "",
        image: ImageModel? = nil,
        caretakers: [String] = [],
        weight: Double = 0.0
    )
}
```

#### UserModel
```swift
public struct UserModel: Identifiable, Codable, Sendable {
    // Complete user profile structure with authentication support
    // (See source code for full implementation)
}
```

### 🔌 DataSource Protocol Interface

```swift
public protocol PetCoreDataSourceProtocol: Sendable {
    func addPet(pet: PetModel) async throws -> ResponseModel<PetModel>
    func fetchOwnerPets(ownerID: String) async throws -> ResponseModel<[PetModel]>
    func fetchPetById(petID: String) async throws -> ResponseModel<PetModel>
    func fetchUserById(userID: String) async throws -> ResponseModel<UserModel>
    func fetchPetType() async throws -> ResponseModel<[PetTypeModel]>
    func editPet(pet: PetModel) async throws -> ResponseModel<PetModel>
    func deletePet(petID: String) async throws -> ResponseModel<String>
}
```

### 🛣️ API Endpoints & Routes

#### RESTful API Endpoints
- **POST** `/pets` - Create new pet
- **GET** `/pets/owner/{ownerID}` - Fetch user's pets
- **GET** `/pets/{petID}` - Fetch specific pet
- **PUT** `/pets/{petID}` - Update pet information
- **DELETE** `/pets/{petID}` - Delete pet
- **GET** `/user/{userID}` - Fetch user information
- **GET** `/pets/animals/types` - Fetch available pet types

#### Navigation Routes
```swift
public enum PetCoreViewRoute: String, Identifiable {
    case dashboard     // Main pet overview
    case createPet     // Pet creation wizard
    case updatePet     // Pet editing interface
    case petProfile    // Detailed pet view
}
```

## Comprehensive Usage Guide

### 🚀 Quick Start Integration

#### Basic Module Initialization
```swift
import PetCoreKitSPM
import SwiftUI

struct ContentView: View {
    var body: some View {
        PetCoreKitSPM.start { 
            print("✅ PetCoreKit initialized successfully")
            // Module is ready for use
        }
    }
}
```

### 🔄 Advanced Data Management with Dependency Injection

#### Complete Pet Management Class
```swift
import PetCoreKitSPM
import SwiftUI
import Factory

@MainActor
class PetManager: ObservableObject {
    @Injected(\PetCoreKitSPM.petCoreDataSource) var petCoreDataSource: PetCoreDataSourceProtocol
    
    @Published var pets: [PetModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchUserPets(ownerID: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: ResponseModel<[PetModel]> = try await petCoreDataSource.fetchOwnerPets(ownerID: ownerID)
            if let fetchedPets: [PetModel] = response.data {
                self.pets = fetchedPets
                print("✅ Successfully fetched \(fetchedPets.count) pets")
            }
        } catch {
            self.errorMessage = "Failed to fetch pets: \(error.localizedDescription)"
            print("❌ Error fetching pets: \(error)")
        }
        
        isLoading = false
    }
    
    func createNewPet(pet: PetModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: ResponseModel<PetModel> = try await petCoreDataSource.addPet(pet: pet)
            if let createdPet: PetModel = response.data {
                self.pets.append(createdPet)
                print("✅ Pet '\(createdPet.name ?? "Unknown")' created successfully")
                return true
            }
        } catch {
            self.errorMessage = "Failed to create pet: \(error.localizedDescription)"
            print("❌ Error creating pet: \(error)")
        }
        
        isLoading = false
        return false
    }
    
    func updatePet(_ pet: PetModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: ResponseModel<PetModel> = try await petCoreDataSource.editPet(pet: pet)
            if let updatedPet: PetModel = response.data {
                if let index: Int = pets.firstIndex(where: { $0.id == updatedPet.id }) {
                    pets[index] = updatedPet
                }
                print("✅ Pet updated successfully")
                return true
            }
        } catch {
            self.errorMessage = "Failed to update pet: \(error.localizedDescription)"
            print("❌ Error updating pet: \(error)")
        }
        
        isLoading = false
        return false
    }
    
    func deletePet(petID: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: ResponseModel<String> = try await petCoreDataSource.deletePet(petID: petID)
            pets.removeAll { $0.id == petID }
            print("✅ Pet deleted successfully")
            return true
        } catch {
            self.errorMessage = "Failed to delete pet: \(error.localizedDescription)"
            print("❌ Error deleting pet: \(error)")
        }
        
        isLoading = false
        return false
    }
}
```

### 🧙‍♂️ Pet Creation Wizard Integration

#### Custom Pet Creation Flow
```swift
import PetCoreKitSPM
import SwiftUI

struct PetCreationContainerView: View {
    @StateObject private var coordinator: PetCoreCoordinator = PetCoreCoordinator.shared
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                Button("Create New Pet") {
                    coordinator.navigate(to: .createPet)
                }
                .buttonStyle(.borderedProminent)
                
                Button("View Dashboard") {
                    coordinator.navigate(to: .dashboard)
                }
                .buttonStyle(.bordered)
            }
            .navigationDestination(for: PetCoreViewRoute.self) { route in
                routeView(for: route)
            }
        }
        .environmentObject(coordinator)
    }
    
    @ViewBuilder
    private func routeView(for route: PetCoreViewRoute) -> some View {
        switch route {
        case .createPet:
            AddPetView()
        case .dashboard:
            DashboardView()
        case .petProfile:
            PetProfileView()
        case .updatePet:
            AddPetView() // Reused for editing
        }
    }
}
```

### 🎛️ Advanced ViewModel Integration

#### Complete Pet Management ViewModel
```swift
import PetCoreKitSPM
import SwiftUI
import Factory

@MainActor
class CustomPetViewController: ObservableObject {
    @Injected(\PetCoreKitSPM.petCoreDataSource) var petCoreDataSource: PetCoreDataSourceProtocol
    
    let petViewModel: PetCoreViewModel = PetCoreViewModel()
    
    @Published var selectedPet: PetModel?
    @Published var isFormValid: Bool = false
    
    func setupNewPetForm() {
        // Configure comprehensive pet creation form
        petViewModel.petName = "Buddy"
        petViewModel.setPetType("DOG")
        petViewModel.setPetBreed("Golden Retriever", breedID: "golden-retriever-123")
        petViewModel.setPetGender("MALE")
        petViewModel.setPetSize("LARGE")
        petViewModel.petWeight = "30.5"
        petViewModel.petDescription = "Friendly and energetic family dog, loves playing fetch and swimming."
        
        // Validate form completion
        validateForm()
    }
    
    func setupEditPetForm(pet: PetModel) {
        selectedPet = pet
        petViewModel.setSelectedPet(pet)
        petViewModel.petName = pet.name ?? ""
        petViewModel.setPetType(pet.petType ?? "")
        petViewModel.setPetBreed(pet.breedName ?? "", breedID: pet.breedID ?? "")
        petViewModel.setPetGender(pet.gender ?? "")
        petViewModel.setPetSize(pet.size ?? "")
        petViewModel.petWeight = pet.weightValue ?? ""
        petViewModel.petDescription = pet.description ?? ""
        
        validateForm()
    }
    
    private func validateForm() {
        isFormValid = petViewModel.isFormComplete
    }
    
    func savePet() async -> Bool {
        guard isFormValid else {
            print("❌ Form validation failed")
            return false
        }
        
        let petModel: PetModel = petViewModel.createPetModel()
        
        if selectedPet?.id != nil {
            // Update existing pet
            return await updateExistingPet(petModel)
        } else {
            // Create new pet
            return await createNewPet(petModel)
        }
    }
    
    private func createNewPet(_ pet: PetModel) async -> Bool {
        do {
            let response: ResponseModel<PetModel> = try await petCoreDataSource.addPet(pet: pet)
            if let createdPet: PetModel = response.data {
                selectedPet = createdPet
                print("✅ Pet '\(createdPet.name ?? "Unknown")' created successfully")
                return true
            }
        } catch {
            print("❌ Error creating pet: \(error)")
        }
        return false
    }
    
    private func updateExistingPet(_ pet: PetModel) async -> Bool {
        var updatedPet: PetModel = pet
        updatedPet.id = selectedPet?.id
        
        do {
            let response: ResponseModel<PetModel> = try await petCoreDataSource.editPet(pet: updatedPet)
            if let editedPet: PetModel = response.data {
                selectedPet = editedPet
                print("✅ Pet updated successfully")
                return true
            }
        } catch {
            print("❌ Error updating pet: \(error)")
        }
        return false
    }
}
```

### 🖼️ Custom Pet Profile with Advanced Features

#### Comprehensive Pet Profile View
```swift
import PetCoreKitSPM
import SwiftUI

struct EnhancedPetProfileView: View {
    @StateObject private var petViewModel: PetCoreViewModel = PetCoreViewModel()
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    let petID: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView("Loading pet information...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if let pet: PetModel = petViewModel.selectedPet {
                    petHeaderSection(pet: pet)
                    petDetailsSection(pet: pet)
                    petHealthSection(pet: pet)
                    petDescriptionSection(pet: pet)
                } else if let error: String = errorMessage {
                    errorView(message: error)
                }
            }
            .padding()
        }
        .navigationTitle("Pet Profile")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadPetData()
        }
        .refreshable {
            await loadPetData()
        }
    }
    
    @ViewBuilder
    private func petHeaderSection(pet: PetModel) -> some View {
        VStack(spacing: 12) {
            // Pet image or placeholder
            AsyncImage(url: URL(string: pet.image?.url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(pet.name ?? "Unknown Pet")
                    .font(.title.bold())
                
                Text(pet.breedName ?? "Mixed Breed")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                if let age: String = petViewModel.calculateAge(from: pet.dateOfBirth ?? "") {
                    Text("Age: \(age)")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func petDetailsSection(pet: PetModel) -> some View {
        GroupBox("Pet Details") {
            VStack(alignment: .leading, spacing: 8) {
                detailRow(title: "Type", value: pet.petType?.capitalized ?? "Unknown")
                detailRow(title: "Gender", value: pet.gender?.capitalized ?? "Unknown")
                detailRow(title: "Size", value: pet.size?.capitalized ?? "Unknown")
                if let weight: String = pet.weightValue, !weight.isEmpty {
                    detailRow(title: "Weight", value: "\(weight) kg")
                }
            }
        }
    }
    
    @ViewBuilder
    private func petHealthSection(pet: PetModel) -> some View {
        GroupBox("Health Information") {
            VStack(alignment: .leading, spacing: 8) {
                if let birthDate: String = pet.dateOfBirth, !birthDate.isEmpty {
                    detailRow(title: "Date of Birth", value: birthDate)
                }
                if let adoptionDate: String = pet.adoptionDate, !adoptionDate.isEmpty {
                    detailRow(title: "Adoption Date", value: adoptionDate)
                }
                detailRow(title: "Lost Status", value: (pet.isLost ?? false) ? "Lost" : "Safe")
            }
        }
    }
    
    @ViewBuilder
    private func petDescriptionSection(pet: PetModel) -> some View {
        if let description: String = pet.description, !description.isEmpty {
            GroupBox("About \(pet.name ?? "Pet")") {
                Text(description)
                    .font(.body)
                    .lineLimit(nil)
            }
        }
    }
    
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.callout.weight(.medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.callout)
        }
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Unable to Load Pet")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Try Again") {
                Task {
                    await loadPetData()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func loadPetData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: ResponseModel<PetModel> = try await petViewModel.petCoreDataSource.fetchPetById(petID: petID)
            if let pet: PetModel = response.data {
                await MainActor.run {
                    petViewModel.setSelectedPet(pet)
                }
            } else {
                errorMessage = "Pet not found"
            }
        } catch {
            errorMessage = "Failed to load pet: \(error.localizedDescription)"
            print("❌ Error loading pet: \(error)")
        }
        
        isLoading = false
    }
}
```

## 🏗️ Enterprise Architecture Overview

### Modern Architectural Patterns

#### MVVM + Coordinator Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   SwiftUI Views │◄──►│   ViewModels     │◄──►│   Coordinators  │
│                 │    │                  │    │                 │
│ - PetCoreRootView │  │ - PetCoreViewModel │  │ - PetCoreCoord. │
│ - DashboardView   │  │                  │    │                 │
│ - AddPetView      │  └──────────────────┘    └─────────────────┘
│ - PetProfileView  │             │                       │
└─────────────────┘             │                       │
         │                       ▼                       ▼
         │              ┌──────────────────┐    ┌─────────────────┐
         │              │   DataSource     │    │   Navigation    │
         │              │                  │    │                 │
         └──────────────┤ - Protocol Layer │    │ - Route Enum    │
                        │ - Implementation │    │ - Sheet Manager │
                        │ - API Integration│    │ - Path Handling │
                        └──────────────────┘    └─────────────────┘
```

#### Data Flow Architecture
```
UI Layer (SwiftUI Views)
    ↓ User Interactions
ViewModel Layer (Business Logic)
    ↓ Data Requests
Coordinator Layer (Navigation & DI)
    ↓ Service Calls
DataSource Layer (API Abstraction)
    ↓ Network Requests
SQAServices (Network Implementation)
    ↓ HTTP/REST
Backend API (Server)
```

### 🔧 Dependency Injection with Factory

#### Container Configuration
```swift
public extension PetCoreKitSPM {
    var petCoreDataSource: Factory<PetCoreDataSourceProtocol> {
        self { PetCoreDataSourceImplementation.shared }
            .singleton  // Ensures single instance across app
    }
}
```

#### Usage in ViewModels
```swift
@MainActor
class ExampleViewModel: ObservableObject {
    @Injected(\PetCoreKitSPM.petCoreDataSource) 
    var petCoreDataSource: PetCoreDataSourceProtocol
    
    // Automatic dependency injection - no manual initialization required
}
```

## 🧪 Testing & Development

### Testing Architecture
- **Unit Tests**: Comprehensive ViewModel and business logic testing
- **Protocol Mocking**: Clean mocking through protocol abstractions
- **Preview Support**: Complete SwiftUI preview implementations for all components
- **Developer Helpers**: Rich mock data and preview utilities

### Development Features
```swift
// Example of developer preview data usage
struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PetProfileView()
            .environmentObject(
                PetCoreDeveloperPreviewHelper.shared.createMockPetCoreViewModel()
            )
            .previewDisplayName("Pet Profile - Sample Data")
    }
}
```

### Mock Data Support
The module includes comprehensive mock data through `PetCoreDeveloperPreviewHelper`:
- Sample pet data for all supported types
- Mock user profiles with authentication states
- Simulated API responses for testing
- Error state simulation for robust testing

## 🚀 Performance & Optimization

### Modern Concurrency
- **Async/Await**: Full adoption of Swift's modern concurrency model
- **Task Management**: Proper task lifecycle management
- **Main Actor**: UI updates properly dispatched to main thread
- **Sendable Compliance**: Thread-safe data models and protocols

### Memory Management
- **@StateObject**: Proper ownership for view model instances
- **@ObservableObject**: Efficient property observation
- **Weak References**: Prevention of retain cycles in coordinators
- **Lazy Loading**: Efficient data loading strategies

### Network Optimization
- **Response Caching**: Intelligent caching through SQAServices
- **Request Batching**: Optimized API call patterns
- **Error Recovery**: Automatic retry mechanisms for network failures
- **Loading States**: Comprehensive loading state management

## 🔒 Security Features

### Data Protection
- **Secure Storage**: Encrypted user data through SQAUtility
- **Token Management**: Secure authentication token handling
- **Input Validation**: Comprehensive form validation and sanitization
- **API Security**: Secure headers and authentication integration

### Privacy Compliance
- **Data Minimization**: Only necessary data collection
- **User Consent**: Built-in privacy controls
- **Secure Transmission**: HTTPS-only API communication
- **Local Data Encryption**: Encrypted local storage

## 📱 Platform Compatibility

### iOS Support
- **iOS 17.0+**: Full feature support with latest iOS capabilities
- **Swift 6.0+**: Modern Swift language features
- **SwiftUI**: Native SwiftUI implementation
- **Accessibility**: Full VoiceOver and accessibility support

### Device Support
- **iPhone**: All screen sizes with responsive design
- **iPad**: Optimized for tablet interfaces
- **Orientation**: Portrait and landscape support
- **Dark Mode**: Complete dark mode implementation

## 🆕 Version History

### Version 1.0.0 (Current)
- ✅ Complete pet CRUD operations
- ✅ Multi-step pet creation wizard
- ✅ Advanced dashboard with interactive cards
- ✅ Comprehensive user management
- ✅ Factory-based dependency injection
- ✅ Protocol-oriented architecture
- ✅ SwiftUI modern patterns
- ✅ Async/await concurrency
- ✅ Comprehensive error handling
- ✅ Developer preview support

### Upcoming Features (Roadmap)
- 📅 Pet appointment scheduling
- 🏥 Veterinary records integration
- 📊 Health tracking and analytics
- 🔔 Smart notifications and reminders
- 🌍 Multi-language support
- 🎨 Customizable themes
- 📱 Widget support for iOS home screen

## 🛠️ Build Configuration

### Package.swift Configuration
```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PetCoreKitSPM",
    platforms: [
        .iOS(.v17)  // Minimum iOS 17.0 support
    ],
    products: [
        .library(
            name: "PetCoreKitSPM",
            targets: ["PetCoreKitSPM"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.3.1"),
        .package(path: "../SQAUtility"),      // Local dependency
        .package(path: "../SQAServices"),     // Local dependency  
        .package(path: "../Shared_kit")       // Local dependency
    ],
    targets: [
        .target(
            name: "PetCoreKitSPM",
            dependencies: [
                .product(name: "Factory", package: "Factory"),
                "SQAUtility",
                "SQAServices", 
                "Shared_kit"
            ],
            resources: [
                .process("Resources")  // Include app assets
            ]
        ),
        .testTarget(
            name: "PetCoreKitSPMTests",
            dependencies: ["PetCoreKitSPM"]
        ),
    ]
)
```

## 📞 Support & Documentation

### Getting Help
- **GitHub Issues**: Report bugs and request features
- **Documentation**: Comprehensive inline code documentation
- **Examples**: Complete working examples in this README
- **Preview Support**: Live SwiftUI previews for all components

### Contributing Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- **Swift 6.0**: Latest Swift language features
- **SwiftUI**: Native SwiftUI patterns and best practices
- **Documentation**: Comprehensive code documentation required
- **Testing**: Unit tests required for all new features
- **Architecture**: Follow established MVVM + Coordinator patterns

## 📄 License
**Proprietary** - All rights reserved by Danis Preldzic

---

## 🏆 Project Highlights

### Technical Excellence
- ✅ **100% SwiftUI**: Modern, declarative UI framework
- ✅ **Type-Safe**: Full Swift type safety with Codable models
- ✅ **Async/Await**: Modern concurrency throughout
- ✅ **Protocol-Oriented**: Clean abstractions and testability
- ✅ **Dependency Injection**: Factory-based DI architecture
- ✅ **Memory Efficient**: Proper object lifecycle management

### User Experience
- ✅ **Intuitive Interface**: User-friendly multi-step wizards
- ✅ **Responsive Design**: Adaptive layouts for all devices
- ✅ **Error Handling**: Comprehensive error states and recovery
- ✅ **Loading States**: Smooth loading experiences
- ✅ **Accessibility**: Full VoiceOver and accessibility support
- ✅ **Performance**: Optimized for smooth 60fps interactions

**Developed by Danis Preldzic**