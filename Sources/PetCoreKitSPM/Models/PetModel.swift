//
//  PetModel.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import Shared_kit
import SwiftUI

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
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "ownerId"
        case name
        case breedID = "breedId"
        case breedName
        case dateOfBirth = "birthDate"
        case adoptionDate
        case gender
        case isLost
        case size
        case petType = "animalType"
        case weightValue
        case description
        case image
        case weight
    }
    
   public init(
         id: String = "",
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
         weight: Double = 0.0)
    {
        self.id = id
        self.ownerID = ownerID
        self.name = name
        self.breedID = breedID
        self.breedName = breedName
        self.dateOfBirth = dateOfBirth
        self.adoptionDate = adoptionDate
        self.gender = gender
        self.isLost = isLost
        self.size = size
        self.petType = petType
        self.weightValue = weightValue
        self.description = description
        self.image = image
        self.weight = weight
    }
}
