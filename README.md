# PetCoreKitSPM

## Overview
PetCoreKitSPM is a Swift Package Module that provides comprehensive core functionality for a pet management system. This module is designed to be integrated into iOS applications as a Swift Package, offering robust features for pet data management, user profiles, multi-step pet creation wizard, and sophisticated UI components following modern iOS design patterns.

## Author
Danis Preldzic

## Requirements
- iOS 17.0+
- Swift 6.0+
- Xcode 15.0+

## Dependencies
- [Factory](https://github.com/hmlongco/Factory) (2.4.5): A Swift dependency injection framework for clean architecture
- SQAUtility: Local dependency providing storage management and utility functions
- SQAServices: Local dependency for network services and API communication
- Shared_kit: Local dependency for shared UI components and breed management

## Features

### Core Pet Management
- **Complete Pet CRUD Operations**: Create, read, update, and delete pet profiles
- **Multi-step Pet Creation Wizard**: 5-step guided process for adding new pets
  - Basic Info (Name, Pet Type)
  - Breed Selection (Dynamic breed fetching)
  - Pet Details (Weight, Description, Physical attributes)
  - Health Info (Birthday, Adoption date)
  - Review & Confirmation
- **Pet Profile Management**: Detailed pet profiles with image management
- **Pet Type Support**: Dogs, Cats, Birds, Reptiles, Small Mammals
- **Dynamic Breed Integration**: Real-time breed fetching based on pet type

### User Management
- **User Profile Fetching**: Retrieve and display user information
- **User Pet Relationships**: Manage pets owned by specific users
- **Secure Authentication**: Token-based authentication with secure storage

### Advanced UI Components
- **Dashboard View**: Overview of user's pets with interactive cards
- **Pet Profile View**: Comprehensive pet information display
- **Image Management**: Integrated image upload and editing capabilities
- **Step-by-step Navigation**: Intuitive multi-step forms with progress indicators
- **Responsive Design**: Adaptive UI for different screen sizes

### Architecture & Design Patterns
- **MVVM Architecture**: Clean separation of concerns
- **Coordinator Pattern**: Centralized navigation management
- **Dependency Injection**: Factory-based DI for testability
- **Protocol-Oriented Design**: Abstracted data access layers
- **SwiftUI Modern Patterns**: @StateObject, @Published, @EnvironmentObject

## Installation

### Swift Package Manager
Add PetCoreKitSPM to your Swift Package dependencies:

```swift
dependencies: [
    .package(url: "path/to/PetCoreKitSPM", from: "1.0.0")
]
```

And include it in your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["PetCoreKitSPM"]),
]
```

## Project Structure

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
    ↓
ViewModel Layer (PetCoreViewModel)
    ↓
Coordinator Layer (PetCoreCoordinator)
    ↓
DataSource Layer (PetCoreDataSourceProtocol)
    ↓
Network Layer (SQAServices)
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