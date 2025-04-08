
import SwiftUI

struct Onboarding: View {
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to")
                    .font(.largeTitle) // da discutere
                Text("Habit Hub!")
                    .foregroundColor(.accentColor)
            }
            .font(.title)
            .fontWeight(.bold)
            Spacer()
            VStack(spacing: 20.0) {
                HStack(spacing: 16.0) {
                    Image(systemName: "checklist")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading) {
                        Text("Track")
                        Text("Start tracking your habits now. Get suggestions and reminders to stay on top of your goals.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack(spacing: 16.0) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 4)
                    VStack(alignment: .leading) {
                        Text("Analyze")
                        Text("Do a deep dive into your statistics and understand your progress for each habit.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack(spacing: 16.0) {
                    Image(systemName: "sparkles")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 6)
                    VStack(alignment: .leading) {
                        Text("Reflect")
                        Text("Take time to review your journey. Use what you've learned to refine your habits and keep improving.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 28)
            .symbolRenderingMode(.hierarchical)
            
            Spacer()
            VStack(spacing: 16.0) {
                VStack(spacing: 6.0) {
                    Image(systemName: "heart.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    Text("Made with love from the Bugs n' Roses team. A big applause for Giusy, Umberto and all of the mentors!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Button {
                    print("Continue tapped!")
                    firstTime.toggle()
                } label: {
                    Text("Continue")
                        .padding(8)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    Onboarding()
}
