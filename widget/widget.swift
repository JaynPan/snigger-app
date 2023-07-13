//
//  widget.swift
//  widget
//
//  Created by 潘傑恩 on 2023/7/10.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        ImageProvider.getImageFromApi() { apodImageResponse in
            var entries: [SimpleEntry] = []
            var policy: TimelineReloadPolicy
            var entry: SimpleEntry
            
            switch apodImageResponse {
            case .Failure:
                entry = SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!)
                policy = .after(Calendar.current.date(byAdding: .minute, value: 15, to: Date())!)
                break
            case .Success(let image):
                entry = SimpleEntry(date: Date(), image: image)
                policy = .after(Calendar.current.date(byAdding: .minute, value: 2, to: Date())!)
                break
            }
            
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
//    var text: String = ""
//    var shouldShowText: Bool = false
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape().fill(.gray.gradient)
            
            Image(uiImage: entry.image)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
        }
        .widgetURL(URL(string: "myapp://photos/123"))
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), image:  UIImage(named: "placeholder")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
