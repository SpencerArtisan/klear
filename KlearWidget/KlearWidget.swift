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

    private let redScheme: [UIColor] = [#colorLiteral(red: 0.8509803922, green: 0, blue: 0.0862745098, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.1137254902, blue: 0.09019607843, alpha: 1), #colorLiteral(red: 0.8745098039, green: 0.2274509804, blue: 0.09411764706, alpha: 1), #colorLiteral(red: 0.8862745098, green: 0.3450980392, blue: 0.09803921569, alpha: 1), #colorLiteral(red: 0.8941176471, green: 0.4588235294, blue: 0.1019607843, alpha: 1), #colorLiteral(red: 0.9058823529, green: 0.5725490196, blue: 0.1058823529, alpha: 1), #colorLiteral(red: 1, green: 0.7647058824, blue: 0.2431372549, alpha: 1)]
    private let greenScheme: [UIColor] = [#colorLiteral(red: 0.4136029482, green: 0.677290082, blue: 0.1465499401, alpha: 1), #colorLiteral(red: 0.4698219299, green: 0.7042465806, blue: 0.160248518, alpha: 1), #colorLiteral(red: 0.5247913599, green: 0.7311549187, blue: 0.1948102415, alpha: 1), #colorLiteral(red: 0.5801013112, green: 0.753967762, blue: 0.2159562707, alpha: 1), #colorLiteral(red: 0.6334363222, green: 0.7807858586, blue: 0.2478569746, alpha: 1), #colorLiteral(red: 0.6862785816, green: 0.8075666428, blue: 0.2727800012, alpha: 1), #colorLiteral(red: 0.725912571, green: 0.8266130686, blue: 0.2885423899, alpha: 1)]
    private let purpleScheme: [UIColor] = [#colorLiteral(red: 0.4787971973, green: 0.314438343, blue: 0.9557709098, alpha: 1), #colorLiteral(red: 0.5438430905, green: 0.3648558259, blue: 0.9623785615, alpha: 1), #colorLiteral(red: 0.6043596864, green: 0.4155195355, blue: 0.9687760472, alpha: 1), #colorLiteral(red: 0.6642792821, green: 0.4703497887, blue: 0.9748064876, alpha: 1), #colorLiteral(red: 0.7253383994, green: 0.5168190002, blue: 0.976685226, alpha: 1), #colorLiteral(red: 0.7727643847, green: 0.5640009642, blue: 0.9867911935, alpha: 1), #colorLiteral(red: 0.8326075673, green: 0.6187940836, blue: 0.9920439124, alpha: 1)]
    private let blueScheme: [UIColor] = [#colorLiteral(red: 0.3049082458, green: 0.5391378999, blue: 0.9297524095, alpha: 1), #colorLiteral(red: 0.3319737911, green: 0.5706816316, blue: 0.9200450778, alpha: 1), #colorLiteral(red: 0.3646841049, green: 0.6021195054, blue: 0.9143176079, alpha: 1), #colorLiteral(red: 0.3931383789, green: 0.6296228766, blue: 0.904502213, alpha: 1), #colorLiteral(red: 0.4270198941, green: 0.657012701, blue: 0.894515872, alpha: 1), #colorLiteral(red: 0.459210813, green: 0.6884343028, blue: 0.8841599822, alpha: 1), #colorLiteral(red: 0.5193114877, green: 0.7473400235, blue: 0.8716130257, alpha: 1)]
    private let grayScheme: [UIColor] = [#colorLiteral(red: 0.5777024627, green: 0.592645824, blue: 0.6052832007, alpha: 1), #colorLiteral(red: 0.60515517, green: 0.6200971007, blue: 0.6327351928, alpha: 1), #colorLiteral(red: 0.6365295649, green: 0.6514698863, blue: 0.6641087532, alpha: 1), #colorLiteral(red: 0.6639820337, green: 0.6789211035, blue: 0.691560626, alpha: 1), #colorLiteral(red: 0.6953561902, green: 0.7102939487, blue: 0.7229340672, alpha: 1), #colorLiteral(red: 0.7228084207, green: 0.7377451062, blue: 0.7503857613, alpha: 1), #colorLiteral(red: 0.7816342711, green: 0.7965689301, blue: 0.8092107177, alpha: 1)]

    fileprivate func colourScheme() -> [UIColor] {
        var scheme = entry.configuration.Colour
        switch (scheme) {
        case Scheme.green: return greenScheme
        case Scheme.purple: return purpleScheme
        case Scheme.blue: return blueScheme
        case Scheme.gray: return grayScheme
        default: return redScheme
        }
    }
    
    fileprivate func colour(index: Int) -> Color {
        return Color(colourScheme()[index])
    }
    
    fileprivate func backgroundColour() -> Color {
        return colour(index: 3)
    }
    
    fileprivate func foregroundColour() -> Color {
        return colour(index: 0)
    }
 
    var shape : RoundedRectangle { RoundedRectangle(cornerRadius: 11) }
    
    fileprivate func verticalItem(text: String) -> some View {
        return Text(text)
            .foregroundColor(.white)
            .font(.footnote)
            .padding(.leading, 10)
            .padding([.top, .bottom], 3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColour())
            .containerShape(shape)
    }
    
    fileprivate func flowItem(text: String) -> some View {
        return Text(text)
            .foregroundColor(.white)
            .font(.footnote)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 3)
            .background(backgroundColour())
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
        let count = min(40, mainItems.count())
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
            foregroundColour()
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
