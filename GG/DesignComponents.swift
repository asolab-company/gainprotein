import SwiftUI

// MARK: - Colors
extension Color {
    static let ggOrange = Color(red: 1.0, green: 70/255, blue: 0) // #FF4600
    static let darkField = Color(white: 0.15) // Dark background for fields
}

// MARK: - Dark Text Field
struct DarkTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.gray)
            }
            .padding()
            .background(Color.darkField)
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
    }
}

// MARK: - Dark Picker Style
struct DarkPickerMenu<SelectionValue: Hashable & CustomStringConvertible>: View {
    let title: String
    @Binding var selection: SelectionValue?
    let options: [SelectionValue]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
                // Dismiss keyboard when opening picker
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                HStack {
                    if isExpanded {
                        Text(title)
                            .foregroundColor(.gray)
                    } else {
                        if let selected = selection {
                            Text(selected.description)
                                .foregroundColor(.white)
                        } else {
                            Text(title)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.caption)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding()
                .background(Color.darkField)
            }
            .zIndex(1)
            
            // Expanded Options
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selection = option
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option.description)
                                    .foregroundColor(.white)
                                Spacer()
                                if selection == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.ggOrange)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(Color.darkField)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Orange Button
struct PrimaryButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3) // Increased from headline
                .bold()
                .italic()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.ggOrange)
                .cornerRadius(8)
        }
    }
}

// MARK: - Glass Card (Retained for Lists)
struct GlassCard<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            content
                .padding()
        }
    }
}

// MARK: - Helpers
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
