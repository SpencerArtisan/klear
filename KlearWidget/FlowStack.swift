//
//  FlowStack.swift
//  KlearWidgetExtension
//
//  Created by Spencer Ward on 04/12/2022.
//  Copyright © 2022 Yorwos Pallikaropoulos. All rights reserved.
//

import Foundation
import SwiftUI

public struct FlowStack<Content: View>: View {
    let content: () -> Content
    let spacing: CGSize

    /// Creates an instance with the given spacing and content.
    ///
    /// - Parameter spacing: A `CGSize` value indicating the space between children.
    /// - Parameter content: A view builder that creates the content of this stack.
    public init(spacing: CGSize = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.spacing = spacing
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Setup for layout pass
            var available: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
            Color.clear
                .frame(height: 0)
                .alignmentGuide(.top) { item in
                    available = item.width
                    x = 0
                    y = 0
                    return 0
                }

            content()
                .alignmentGuide(.leading) { item in
                    if x + item.width > available {
                        x = 0
                        y += item.height + spacing.height
                    }
                    let result = x
                    x += item.width + spacing.width
                    return -result
                }
                .alignmentGuide(.top) { _ in
                    -y
                }
        }
    }
}