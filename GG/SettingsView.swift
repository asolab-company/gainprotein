import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var legalStore: LegalStore
    
    // State for navigation
    @State private var showShareSheet = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Navigation Links for Legal Pages
            NavigationLink(destination: LegalView(title: "Terms and Conditions", content: legalStore.termsAndConditions), isActive: $showTerms) { EmptyView() }
            NavigationLink(destination: LegalView(title: "Privacy Policy", content: legalStore.privacyPolicy), isActive: $showPrivacy) { EmptyView() }
            
            VStack(spacing: 24) {
                // Header
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    
                    Text("Settings")
                        .font(.headline)
                        .italic()
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                // Options
                VStack(spacing: 16) {
                    SettingsButton(title: "Share app") {
                        showShareSheet = true
                    } icon: {
                        Image("settings_share")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    SettingsButton(title: "Terms and Conditions") {
                        showTerms = true
                    } icon: {
                        Image("settings_doc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    SettingsButton(title: "Privacy") {
                        showPrivacy = true
                    } icon: {
                        Image("settings_shield")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["Check out this Protein Calculator app! It helps you reach your fitness goals.", URL(string: "https://apps.apple.com")!])
        }
    }
}

// Share Sheet Wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Custom Share Icon Drawing
struct ShareIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Coordinates (based on a typical 24x24 grid logic)
        // Left dot: (6, 12)
        // Top Right dot: (18, 6)
        // Bottom Right dot: (18, 18)
        
        let leftCenter = CGPoint(x: width * 0.25, y: height * 0.5)
        let topRightCenter = CGPoint(x: width * 0.75, y: height * 0.25)
        let bottomRightCenter = CGPoint(x: width * 0.75, y: height * 0.75)
        
        let dotRadius = width * 0.15 // approx 3.6pt on 24pt
        
        // Lines
        // Line thickness approx 2pt? standardized by stroking or filling a rect?
        // Let's just draw lines from center to centers, and we'll STROKE this shape or combine paths.
        // Actually, to make it a fillable shape (like a glyph), it's easier to compose circles and thick lines.
        // But simpler: Draw circles, add lines.
        
        path.addArc(center: leftCenter, radius: dotRadius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.addArc(center: topRightCenter, radius: dotRadius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.addArc(center: bottomRightCenter, radius: dotRadius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        
        // Create a separate path for lines to stroke them? No, returning one path.
        // We can mimic lines with thin rotated rectangles if we want a filled shape.
        // Or we function it as a view.
        
        return path
    }
}

// View wrapper for easier styling (Stroke+Fill combined)
struct ShareIconView: View {
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            
            let leftCenter = CGPoint(x: width * 0.25, y: height * 0.5)
            let topRightCenter = CGPoint(x: width * 0.75, y: height * 0.25)
            let bottomRightCenter = CGPoint(x: width * 0.75, y: height * 0.75)
            
            let dotRadius = width * 0.18
            
            // Draw Lines
            let linePath = Path { p in
                p.move(to: leftCenter)
                p.addLine(to: topRightCenter)
                p.move(to: leftCenter)
                p.addLine(to: bottomRightCenter)
            }
            context.stroke(linePath, with: .color(.ggOrange), lineWidth: width * 0.15)
            
            // Draw Dots
            for center in [leftCenter, topRightCenter, bottomRightCenter] {
                let dotRect = CGRect(x: center.x - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
                context.fill(Path(ellipseIn: dotRect), with: .color(.ggOrange))
            }
        }
    }
}

struct SettingsButton<Icon: View>: View {
    let title: String
    var action: () -> Void
    let icon: Icon
    
    init(title: String, action: @escaping () -> Void, @ViewBuilder icon: () -> Icon) {
        self.title = title
        self.action = action
        self.icon = icon()
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                icon
                
                Text(title)
                    .font(.system(size: 16, weight: .bold)) // Bold weight matches screenshot
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
            }
            .padding()
            .frame(height: 56) // Fixed height often helps match designs
            .background(Color(white: 0.12)) // Dark gray fill
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 1) // Solid white stroke based on screenshot
            )
        }
    }
}

#Preview {
    SettingsView()
}
