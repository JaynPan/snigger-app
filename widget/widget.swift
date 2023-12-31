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
        SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!, id: "cats/00a08d6b-cb86-4189-85df-fbd663aa1991.png")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!, id: "cats/00a08d6b-cb86-4189-85df-fbd663aa1991.png")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        ImageProvider.getImageFromApi() { apodImageResponse in
            var entries: [SimpleEntry] = []
            var policy: TimelineReloadPolicy
            var entry: SimpleEntry
            
            switch apodImageResponse {
            case .Failure:
                entry = SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!, id: "123")
                policy = .after(Calendar.current.date(byAdding: .minute, value: 15, to: Date())!)
                break
            case .Success(let image, let id):
                entry = SimpleEntry(date: Date(), image: image, id: id)
                policy = .after(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
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
    let id: String
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
        .widgetURL(URL(string: "myapp://photodetail?id=\(entry.id)"))
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
        widgetEntryView(entry: SimpleEntry(date: Date(), image:  UIImage(named: "placeholder")!, id: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
