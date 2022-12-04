//
//  KlearWidget.swift
//  KlearWidget
//
//  Created by Spencer Ward on 02/10/2022.
//  Copyright © 2022 Yorwos Pallikaropoulos. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset * 10, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct KlearWidgetEntryView : View {
    var entry: Provider.Entry

    private let colors: [UIColor] = [#colorLiteral(red: 0.8509803922, green: 0, blue: 0.0862745098, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.1137254902, blue: 0.09019607843, alpha: 1), #colorLiteral(red: 0.8745098039, green: 0.2274509804, blue: 0.09411764706, alpha: 1), #colorLiteral(red: 0.8862745098, green: 0.3450980392, blue: 0.09803921569, alpha: 1), #colorLiteral(red: 0.8941176471, green: 0.4588235294, blue: 0.1019607843, alpha: 1), #colorLiteral(red: 0.9058823529, green: 0.5725490196, blue: 0.1058823529, alpha: 1), #colorLiteral(red: 1, green: 0.7647058824, blue: 0.2431372549, alpha: 1)]
 
    var shape : RoundedRectangle { RoundedRectangle(cornerRadius: 11) }
    
    fileprivate func verticalItem(text: String) -> some View {
        return Text(text)
            .foregroundColor(.white)
            .font(.footnote)
            .padding(.leading, 10)
            .padding([.top, .bottom], 3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(colors[3]))
            .containerShape(shape)
    }
    
    fileprivate func flowItem(text: String) -> some View {
        return Text(text)
            .foregroundColor(.white)
            .font(.footnote)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 3)
            .background(Color(colors[3]))
            .containerShape(shape)
    }
    
    fileprivate func list() -> String {
        return entry.configuration.List ?? "Personal"
    }
    
    fileprivate func verticalItems() ->  [some View] {
        let mainItems: ToDos = ItemRepo.allIn(moc: CoreDataStack.regularStore().moc!, list: list())
        let count = min(5, mainItems.count())
        let displayItems = (count > 0) ? mainItems.todos[0...count - 1] : []
        return displayItems.map { verticalItem(text: $0.getTitle()) }
    }
    
    fileprivate func flowItems() ->  [some View] {
        let mainItems: ToDos = ItemRepo.allIn(moc: CoreDataStack.regularStore().moc!, list: list())
        let count = min(4, mainItems.count())
        let displayItems = (count > 0) ? mainItems.todos[0...count - 1] : []
        return displayItems.map { flowItem(text: $0.getTitle()) }
    }
    
    fileprivate func flow() -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(list())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .font(.footnote)
            FlowStack(spacing: CGSize(width: 4, height: 4)) {
                ForEach(0..<self.flowItems().count) { index in
                    self.flowItems()[index]
                }
            }
        }
    }
    
    fileprivate func vertical() -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(list())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .font(.footnote)
            ForEach(0..<self.verticalItems().count) { index in
                self.verticalItems()[index]
            }
        }
    }
    
    @ViewBuilder var itemView: some View {
        if (entry.configuration.Display == Display.flow) {
            flow()
        } else {
            vertical()
        }
    }
    
    var body: some View {
        ZStack {
            Color(colors[0])
            ZStack {
                itemView
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 6)
            }
            .padding(.horizontal, 8.0)
        }
    }
}

@main
struct KlearWidget: Widget {
    let kind: String = "KlearWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KlearWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct KlearWidget_Previews: PreviewProvider {
    static var previews: some View {
        KlearWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
