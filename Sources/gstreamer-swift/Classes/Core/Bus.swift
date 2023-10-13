//
//  Bus.swift
//  gstreamer-swift
//
//  Created by @graphiclife on September 25, 2023.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import gstreamer

public final class Bus {
    public let bus: UnsafeMutablePointer<GstBus>

    public init(bus: UnsafeMutablePointer<GstBus>) {
        self.bus = bus
        gst_object_ref(bus)
    }

    deinit {
        gst_object_unref(bus)
    }

    public func watch() -> Source {
        let source: UnsafeMutablePointer<GSource> = gst_bus_create_watch(bus)

        defer {
            g_source_unref(source)
        }

        return .init(source: source)
    }
    
    @discardableResult
    public func emitSignals(in context: MainContext) -> Self {
        let source = watch()
        g_source_set_callback(source.source, gst_bus_w_async_signal_func, nil, nil)
        source.attach(to: context)
        return self
    }
}

extension Bus: GObjectWrapper {
    public var gObject: UnsafeMutablePointer<GObject> {
        return bus.withMemoryRebound(to: GObject.self, capacity: 1) { object in
            return object
        }
    }
}
