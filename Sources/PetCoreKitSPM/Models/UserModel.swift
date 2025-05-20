//
//  UserModel.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import Shared_kit

public struct UserModel: Identifiable, Codable, Sendable {
    public var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var dateOfBirth: String?
    var gender: String?
    var finishedOnboarding: Bool?
    var address: String?
    var state: String?
    var city: String?
    var zipCode: String?
    var image: ImageModel?
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var authProvider: String?
    var authProviderId: String?
    var favoriteServices: [String]?
    var favoriteParks: [String]?
    
    init(id: String = "", firstName: String = "", lastName: String = "", email: String = "", phone: String = "", dateOfBirth: String = "", gender: String = "", finishedOnboarding: Bool = false, address: String = "", state: String = "", zipCode: String = "", image: ImageModel? = nil, city: String = "", latitude: String = "", longitude: String = "", createdAt: String = "", updatedAt: String = "", authProvider: String = "", authProviderId: String = "", favoriteServices: [String]? = nil, favoriteParks: [String]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.finishedOnboarding = finishedOnboarding
        self.address = address
        self.state = state
        self.city = city
        self.zipCode = zipCode
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.authProvider = authProvider
        self.authProviderId = authProviderId
        self.favoriteServices = favoriteServices
        self.favoriteParks = favoriteParks
    }
}
