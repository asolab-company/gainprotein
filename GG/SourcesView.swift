import SwiftUI

struct SourcesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
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
                    
                    Text("Sources")
                        .font(.headline)
                        .italic()
                        .foregroundColor(.white)
                }
                .padding()
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Section 1: Daily Protein Intake Result
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Protein Intake Result")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("This estimate is calculated based on your body weight, activity level, age, sex, and fitness goal, using scientifically recognized nutritional guidelines.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Section 2: Methodology
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Methodology")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("The protein intake calculation is derived from established research and recommendations in sports nutrition and health science.\nProtein needs are adjusted based on factors such as physical activity level, muscle-building goals, age-related muscle preservation, and biological sex.\nThe calculation follows a protein intake range commonly recommended for individuals engaging in moderate physical activity and muscle gain goals.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Section 3: Scientific Sources
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Scientific Sources")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("This calculation is based on recommendations and findings from the following authoritative sources:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // ISSN
                            SourceItem(
                                title: "• International Society of Sports Nutrition (ISSN)",
                                description: "Protein intake of approximately 1.6–2.2 g per kg of body weight is recommended for muscle growth and physically active individuals.",
                                link: "https://jissn.biomedcentral.com/articles/10.1186/s12970-017-0177-8"
                            )
                            
                            // WHO
                            SourceItem(
                                title: "• World Health Organization (WHO)",
                                description: "Protein requirements may increase with higher levels of physical activity.",
                                link: "https://www.who.int/publications/i/item/WHO-TRS-935"
                            )
                            
                            // NIH
                            SourceItem(
                                title: "• National Institutes of Health (NIH)",
                                description: "Higher protein intake may support muscle mass maintenance across different age groups.",
                                link: "https://pubmed.ncbi.nlm.nih.gov/29207555/"
                            )
                            
                            // EFSA
                            SourceItem(
                                title: "• European Food Safety Authority (EFSA)",
                                description: "Protein requirements can vary depending on body composition and biological sex.",
                                link: "https://www.efsa.europa.eu/en/efsajournal/pub/2557"
                            )
                        }
                        
                        // Section 4: Disclaimer
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Disclaimer")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("This calculation is provided for informational and educational purposes only and does not constitute medical advice.\nAlways consult a qualified healthcare professional before making significant dietary changes.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SourceItem: View {
    let title: String
    let description: String
    let link: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
            
            Link(destination: URL(string: link)!) {
                Text(link)
                    .font(.caption)
                    .foregroundColor(.ggOrange)
                    .underline()
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

#Preview {
    SourcesView()
}
