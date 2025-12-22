import SwiftUI

struct LegalView: View {
    let title: String
    let content: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                
                // Content
                ScrollView {
                    Text(try! AttributedString(markdown: content))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
