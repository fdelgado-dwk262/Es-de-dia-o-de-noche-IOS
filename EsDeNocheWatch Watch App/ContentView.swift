import SwiftUI

// MARK: - PUNTO DE ENTRADA ÚNICO PARA WATCH
@main
struct WatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
    }
}

struct WatchContentView: View {
    @State private var currentDate = Date()
    
    var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: currentDate)
        return hour >= 20 || hour < 6
    }
    
    var body: some View {
        ZStack {
            // Fondo optimizado para batería (negro puro si es noche)
            Group {
                if isNight {
                    Color.black
                } else {
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 5) {
                Text(isNight ? "🌙" : "☀️")
                    .font(.system(size: 55))
                
                Text(isNight ? "Es de noche" : "Es de día")
                    .font(.headline)
                    .minimumScaleFactor(0.8)
                
                Text(currentDate, style: .time)
                    .font(.caption2)
                    .opacity(0.6)
                
                Spacer()
                
                Button(action: {
                    currentDate = Date()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                .tint(.white.opacity(0.2))
                .controlSize(.small)
            }
            .padding(.top, 5)
        }
    }
}
