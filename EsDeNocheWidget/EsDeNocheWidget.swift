import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) { completion(SimpleEntry(date: Date())) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [SimpleEntry(date: Date())], policy: .atEnd))
    }
}

struct EsDeNocheWidgetEntryView : View {
    var entry: Provider.Entry
    var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: entry.date)
        return hour >= 20 || hour < 6
    }

    var body: some View {
        VStack {
            Text(isNight ? "🌙" : "☀️")
                .font(.system(size: 40))
            Text(isNight ? "Noche" : "Día")
                .font(.caption.bold())
                .foregroundColor(.white)
        }
        // SOLUCIÓN AL ERROR DE 'buildExpression' y 'AnyGradient'
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: isNight ? [Color.black, Color.blue.opacity(0.3)] : [Color.blue, Color.cyan],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

@main // Único punto de entrada del Widget
struct EsDeNocheWidget: Widget {
    let kind: String = "EsDeNocheWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EsDeNocheWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Estado del Cielo")
        .supportedFamilies([.systemSmall])
    }
}
