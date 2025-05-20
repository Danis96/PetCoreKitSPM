# PetCoreKitSPM

## Overview
PetCoreKitSPM is a Swift Package Module that provides core functionality for a pet management system. This module is designed to be integrated into iOS applications as a Swift Package, offering features related to pet data management, user profiles, and UI components.

## Author
Danis Preldzic

## Requirements
- iOS 17.0+
- Swift 6.0+
- Xcode 15.0+

## Dependencies
- [Factory](https://github.com/hmlongco/Factory) (2.3.1+): A Swift dependency injection framework
- SQAUtility: Local dependency for utility functions
- SQAServices: Local dependency for services
- Shared_kit: Local dependency for shared components

## Features
- Pet management (creation, fetching, updating)
- User profile management
- Coordinator pattern for navigation
- MVVM architecture
- Data source abstraction for API communication

## Installation

### Swift Package Manager
Add PetCoreKitSPM to your Swift Package dependencies:

```swift
dependencies: [
    .package(url: "path/to/PetCoreKitSPM", from: "1.0.0")
]
```

And then include it in your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["PetCoreKitSPM"]),
]
```

## Project Structure

### Models
- `PetModel`: Represents pet information including details like name, breed, weight, etc.
- `UserModel`: Represents user information
- `ImageModel`: Handles image data
- `ResponseModel`: Generic response model for API calls

### ViewModels
- `PetCoreViewModel`: Manages the business logic for pet-related operations

### Coordinators
- `PetCoreCoordinator`: Manages navigation flow within the pet management features

### DataSource
Contains implementations for data retrieval and storage:
- Internal: Local data operations
- External: API communication

### Views
UI components specific to pet management

## Usage

### Initialization
```swift
import PetCoreKitSPM
import SwiftUI

struct MyView: View {
    var body: some View {
        PetCoreKitSPM.start { 
            // Completion handler after initialization
            print("PetCoreKit initialized")
        }
    }
}
```

### Accessing Pet Data
```swift
import PetCoreKitSPM
import SwiftUI
import Factory

class MyViewModel: ObservableObject {
    @Injected(\PetCoreKitSPM.petCoreDataSource) var petCoreDataSource: PetCoreDataSourceProtocol
    
    func fetchPetData(petId: String) async {
        let response = try? await petCoreDataSource.fetchPetById(petId: petId)
        // Handle the response
    }
}
```

### User Management
```swift
import PetCoreKitSPM
import SwiftUI

class UserManager {
    let viewModel = PetCoreViewModel()
    
    func getCurrentUser() async {
        let response = await viewModel.getUser()
        // Handle the user data
    }
}
```

## Architecture

PetCoreKitSPM follows the MVVM (Model-View-ViewModel) pattern with a Coordinator for navigation:

1. **Models**: Define the data structures
2. **Views**: Handle the UI representation
3. **ViewModels**: Manage business logic and data transformation
4. **Coordinators**: Handle navigation flow
5. **DataSource**: Abstract data access layer

The module uses Factory for dependency injection, making it easy to test and maintain.

## License
Proprietary - All rights reserved 