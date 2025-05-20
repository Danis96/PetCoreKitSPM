import SwiftUI
import Factory
import SQAUtility

struct ActivePetCardViewComponent: View {
    
    @Injected(\SQAUtility.colorHelper) var colorHelper: ColorHelper
    
    // MARK: - Properties
    private let petName: String
    private let petBreed: String
    private let petType: String
    private let petImage: String
    private let onTap: () -> Void
    
    // MARK: - Initialization
    init(petName: String, petBreed: String, petType: String, petImage: String, onTap: @escaping () -> Void = {}) {
        self.petName = petName
        self.petBreed = petBreed
        self.petType = petType
        self.petImage = petImage
        self.onTap = onTap
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            background
            HStack {
                petInfoComponent
                Spacer()
                petImageComponent
            }
        }
        .frame(width: .infinity, height: 150)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
    }
}

extension ActivePetCardViewComponent {
    
    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorHelper.getColor(.blue500),
                colorHelper.getColor(.blue700),
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .cornerRadius(16)
    }
    
    private var petInfoComponent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(petName)
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 4) {
                Text(petType)
                    .font(.system(size: 20))
                Text("|")
                    .font(.system(size: 20))
                    .padding(.horizontal, 8)
                Text(petBreed)
                    .font(.system(size: 20))
            }
            .foregroundColor(.white.opacity(0.9))
        }
        .padding(.leading, 24)
        .padding(.vertical)
    }
    
    private var petImageComponent: some View {
        ZStack {
            // Blue circle background
            Circle()
                .fill(Color(red: 0.37, green: 0.52, blue: 0.93).opacity(0.6))
                .frame(width: 120, height: 120)
            
            // Pet Image
            AsyncImage(url: URL(string: petImage)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                }
            }
        }
        .padding(.trailing, 24)
    }
}

// Example usage
struct PetCardPreview: PreviewProvider {
    static var previews: some View {
        
        VStack {
            ActivePetCardViewComponent(
                petName: "Mjaui",
                petBreed: "Mix Breed",
                petType: "Cat",
                petImage: "https://hips.hearstapps.com/hmg-prod/images/playful-golden-british-shorthair-cat-royalty-free-image-1701453627.jpg?crop=0.699xw:1.00xh;0.141xw,0&resize=980:*"
            )
            .padding()
            .previewLayout(.sizeThatFits)
            
            ActivePetCardViewComponent(
                petName: "Doggy",
                petBreed: "Xoloitzcuintle",
                petType: "Dog",
                petImage: "https://moderndogmagazine.com/wp-content/uploads/2011/09/Xolo_bigstock_197084020_Masarik-819x1024.jpg"
            )
            .padding()
            .previewLayout(.sizeThatFits)
        }
        
        
    }
}
