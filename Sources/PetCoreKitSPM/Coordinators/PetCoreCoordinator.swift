//
//  PetCoreCoordinator.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

import SwiftUI
import Factory
import SQAUtility

@MainActor
public final class PetCoreCoordinator: CoordinatorProtocol {
    
    
    public static let shared = PetCoreCoordinator()
    
    // MARK: - Protocol Requirements
    public typealias Route = PetCoreViewRoute
    @Published public var path = NavigationPath()
    
    // MARK: - View Models
    @Published public private(set) var petCoreViewModel: PetCoreViewModel
    
    // MARK: - Navigation
    @Published public var sheet: PetCoreViewRoute?
    
    private init() {
        self.petCoreViewModel = PetCoreViewModel()
    }
    
    // MARK: - CoordinatorProtocol Methods
    public func start(onComplete: @escaping () -> Void) -> AnyView {
        print("Starting Pet Core Kit Coordinator")
        return AnyView(
            Text("Pet core coordinator")
//            ImageKitPicker(selectedImage: imageKitViewModel.selectedImage,
//                           placeholderText: "Select an image")
//            .environmentObject(imageKitViewModel)
//            .environmentObject(self)
        )
    }
    
    public func navigate(to route: PetCoreViewRoute) {
        path.append(route)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func present(_ route: PetCoreViewRoute) {
        sheet = route
    }
    
    public func dismissSheet() {
        sheet = nil
    }
}

