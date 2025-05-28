//
//  PetCoreDeveloperPreviewHelper.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 28. 5. 2025..
//


import Foundation
import SwiftUI
import Shared_kit

extension Preview {
    static var dev: PetCoreDeveloperPreview {
        return PetCoreDeveloperPreview.shared
    }
}

extension Optional where Wrapped == String {
    var isNotNilOrEmpty: Bool {
        guard let value = self else { return false }
        return !value.isEmpty
    }
}

@MainActor
class PetCoreDeveloperPreview {
    static let shared = PetCoreDeveloperPreview()
    
    // MARK: - ViewModels
    public lazy var breedViewModel: BreedKitViewModel = {
        let vm = BreedKitViewModel()
        return vm
    }()

    public lazy var petCoreViewModel: PetCoreViewModel = {
        let vm = PetCoreViewModel()
        return vm
    }()
    
    // MARK: - Coordinators
    public lazy var breedCoordinator: BreedKitCoordinator = {
        let bc = BreedKitCoordinator.shared
        return bc
    }()
    
    public lazy var petCoreCoordinator: PetCoreCoordinator = {
        let ic = PetCoreCoordinator.shared
        return ic
    }()
    
    
    // MARK: - Mock Data
    public var previewBreed: BreedModel {
        let jsonData: Data = jsonBreed.data(using: .utf8)!
        let decoder: JSONDecoder = JSONDecoder()
        
        do {
            return try decoder.decode(BreedModel.self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return BreedModel()
        }
    }

    public var previewAnimalType: [PetTypeModel] {
        let jsonData: Data = jsonAnimalType.data(using: .utf8)!
        let decoder: JSONDecoder = JSONDecoder()
        
        do {
            return try decoder.decode([PetTypeModel].self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    
    let jsonBreed: String = """
        {
            "id": "02c3b1df-1f5e-44f0-9c28-7bd99b834621",
            "description": "American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.",
            "old_id": "abob",
            "life_span": "11 - 15",
            "name": "American Bobtail",
            "origin": "United States",
            "reference_image": "https://ik.imagekit.io/petpals/cats/abob.png?updatedAt=1724704899228",
            "reference_image_id": "hBXicehMA",
            "temperament": "Intelligent, Interactive, Lively, Playful, Sensitive",
            "weight": {
                "metric": "3 - 7",
                "imperial": "7 - 16"
            }
        }
        """

    let jsonAnimalType: String = """
        [
        {
        "id": "47d14da4-551e-41e3-b747-cca0e059e8b8",
        "img": "https://ik.imagekit.io/petpals/animaltypes/reptile.png?updatedAt=1724756658221",
        "type": "REPTILE"
        },
        {
        "id": "cfface7d-9d23-43d5-8ec4-0f47ed4d23c1",
        "img": "https://ik.imagekit.io/petpals/animaltypes/dog.png?updatedAt=1724756145312",
        "type": "DOG"
        },
        {
        "id": "3bf9299a-e071-4f2a-8cbb-d09e5ea54313",
        "img": "https://ik.imagekit.io/petpals/animaltypes/cat.png?updatedAt=1724756368941",
        "type": "CAT"
        },
        {
        "id": "15ff6486-8b26-4f93-82c1-5ed33880a321",
        "img": "https://ik.imagekit.io/petpals/animaltypes/small.png?updatedAt=1724756546901",
        "type": "SMALL_MAMMAL"
        },
        {
        "id": "1a2a310b-7909-440c-88a0-03b60c866e0f",
        "img": "https://ik.imagekit.io/petpals/animaltypes/bird.png?updatedAt=1724756482615",
        "type": "BIRD"
        }
        ]
        """
    
    private init() { }
}

public extension View {
    func withPetCorePreviewDependecies() -> some View {
        self
            .environmentObject(Preview.dev.petCoreCoordinator)
            .environmentObject(Preview.dev.petCoreViewModel)
            .environmentObject(Preview.dev.breedCoordinator)
            .environmentObject(Preview.dev.breedViewModel)
    }
}




