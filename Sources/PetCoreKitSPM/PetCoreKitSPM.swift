// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import SwiftUI

final public class PetCoreKitSPM: SharedContainer {
    public let manager = ContainerManager()
    public static let shared = PetCoreKitSPM()
}

public extension PetCoreKitSPM {
    
    var petCoreDataSource: Factory<PetCoreDataSourceProtocol> {
        self { PetCoreDataSourceImplementation.shared }
            .singleton
    }
    
    @MainActor
    static func start(onComplete: @escaping () -> Void) -> some View {
        PetCoreCoordinator.shared.start(onComplete: onComplete)
    }
    
}
