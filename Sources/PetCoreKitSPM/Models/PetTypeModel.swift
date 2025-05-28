//
//  PetTypeModel.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

public struct PetTypeModel: Identifiable, Codable, Sendable, Hashable {
    
    public var id: String?
    var type: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case image = "img"
    }
    
    public init(id: String = "", type: String = "", image: String = "") {
        self.id = id
        self.type = type
        self.image = image
    }
}
