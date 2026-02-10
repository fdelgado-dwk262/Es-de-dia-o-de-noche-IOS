import SwiftUI
import Combine

// MARK: - Punto de Entrada de la Aplicación
@main
struct EsDeNocheApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Vista Principal
struct ContentView: View {
    @State private var currentDate = Date()
    @State private var isFloating = false
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: currentDate)
        return hour >= 20 || hour < 6
    }
    
    var body: some View {
        ZStack {
            // Fondo dinámico basado en la hora
            LinearGradient(
                colors: isNight ? [Color(red: 0.02, green: 0.02, blue: 0.1), .black] : [.blue, .cyan],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icono con contenedor de altura fija para evitar recortes
                ZStack {
                    Text(isNight ? "🌙" : "☀️")
                        .font(.system(size: 110))
                        .shadow(color: isNight ? .blue.opacity(0.6) : .yellow.opacity(0.6), radius: 25)
                        .offset(y: isFloating ? -20 : 20)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isFloating)
                }
                .frame(height: 160)
                
                VStack(spacing: 12) {
                    Text(isNight ? "Es de noche" : "Es de día")
                        .font(.system(.largeTitle, design: .rounded).bold())
                    
                    Text(isNight ? "Momento de descansar." : "Disfruta de la luz del sol.")
                        .font(.title3)
                        .opacity(0.8)
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        currentDate = Date()
                    }
                }) {
                    Text("Actualizar estado")
                        .font(.headline)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .onAppear { isFloating = true }
        .onReceive(timer) { currentDate = $0 }
    }
}
