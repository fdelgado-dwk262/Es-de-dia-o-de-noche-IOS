import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) { completion(SimpleEntry(date: Date())) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [SimpleEntry(date: Date())]
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct EsDeNocheWidgetEntryView : View {
    var entry: Provider.Entry
    var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: entry.date)
        return hour >= 20 || hour < 6
    }

    var body: some View {
        VStack(spacing: 5) {
            Text(isNight ? "🌙" : "☀️")
                .font(.system(size: 35))
            Text(isNight ? "Noche" : "Día")
                .font(.system(.subheadline, design: .rounded).bold())
                .foregroundColor(.white)
        }
        // Corrección del error buildExpression/AnyGradient
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: isNight ? [Color.black, Color(red: 0.1, green: 0.1, blue: 0.3)] : [Color.blue, Color.cyan],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// Único punto de entrada permitido para el Widget
@main
struct EsDeNocheWidget: Widget {
    let kind: String = "EsDeNocheWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EsDeNocheWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("¿Es de noche?")
        .supportedFamilies([.systemSmall])
    }
}
