//
//  My_Widget.swift
//  My Widget
//
//  Created by Eric Barnes on 7/20/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = MapLayerEntry
    typealias Intent = ViewMapLayerIntent
    
    // quickly returns dummy view of widget 
    func placeholder(in context: Context) -> Entry {
        MapLayerEntry(date: Date(), mapLayer: MapLayer.roadWork, text: "placeholder")
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = MapLayerEntry(date: Date(), mapLayer: getLayer(for: configuration), text: "placeholder") // use layer that user selected to create entry
        completion(entry)
    }

    // timeline of widget states
    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MapLayerEntry] = []
        
        let currentDate = Date()
        let userDefaults = UserDefaults.init(suiteName: "group.widgetCache9999")
        let userText = userDefaults?.string(forKey: "text") ?? "NO TEXT"

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry2 = MapLayerEntry(date: entryDate, mapLayer: getLayer(for: configuration), text: userText)
            entries.append(entry2)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    // function to map user configured value to a map layer type
    func getLayer(for config: ViewMapLayerIntent) -> MapLayer {
        switch config.mapLayer {
        case .crash:
            return .crash
        case .roadWork:
            return .roadWork
        case .weather:
            return .weather
        case .incident:
            return .incident
        case .unknown:
            return .unknown
        }
    }
}

struct MapLayerEntry: TimelineEntry {
    var date: Date
    let mapLayer: MapLayer
    let text: String
}

public enum MapLayer: String {
    case crash = "crash"
    case roadWork = "roadWork"
    case incident = "incident"
    case weather = "weather"
    case unknown = "unknown"
}

struct MapLayerView: View {
    let layer: MapLayer
    
    var body: some View {
        switch layer {
        case .crash, .incident, .roadWork, .weather:
            VStack {
                Text("Configured: ")
                    .bold()
                Text(layer.rawValue)
            }
        default:
            fatalError("map layer view could not read layer or unknown")
        }
    }
}

struct My_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            VStack {
                MapLayerView(layer: entry.mapLayer)
                Text("Sent from app: ")
                    .bold()
                Text(entry.text)
            }
        }
    }
}

@main
struct My_Widget: Widget {
    let kind: String = "My_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider()) { entry in
            My_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My widget")
        .description("This is an example widget.")
    }
}

struct My_Widget_Previews: PreviewProvider {
    static var previews: some View {
        let mapLayerEntry = MapLayerEntry(date: Date(), mapLayer: MapLayer.roadWork, text: "user text")
        My_WidgetEntryView(entry: mapLayerEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
