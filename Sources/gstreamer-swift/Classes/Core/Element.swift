//
//  Element.swift
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

public enum ElementError: Error {
    case linkFailed
    case padMissing
}

public class Element {
    public let element: UnsafeMutablePointer<GstElement>

    public convenience init(_ factoryName: String, name: String? = nil) {
        let element: UnsafeMutablePointer<GstElement> = gst_element_factory_make(factoryName, name)

        defer {
            gst_object_unref(element)
        }

        self.init(element: element)
    }

    public required init(element: UnsafeMutablePointer<GstElement>) {
        self.element = element
        gst_object_ref(element)
    }

    deinit {
        gst_object_unref(element)
    }

    @discardableResult
    public func set(_ key: String, to value: GValueCodable) -> Self {
        set(value: value, forKey: key)
        return self
    }

    @discardableResult
    public func add(to bin: Bin) -> Self {
        bin.element.withMemoryRebound(to: GstBin.self, capacity: 1) { bin in
            if gst_bin_add(bin, element) != 0 {
                gst_object_ref(element)
            }
        }

        return self
    }

    @discardableResult
    public func link(to dest: Element) throws -> Self {
        if gst_element_link(element, dest.element) == 0 {
            throw ElementError.linkFailed
        }

        return self
    }

    @discardableResult
    public func link(pad: String, to dest: Element, destPad: String) throws -> Self {
        if gst_element_link_pads(element, pad, dest.element, destPad) == 0 {
            throw ElementError.linkFailed
        }

        return self
    }

    public func pad(static name: String) throws -> Pad {
        guard let pad = gst_element_get_static_pad(element, name) else {
            throw ElementError.padMissing
        }

        defer {
            gst_object_unref(pad)
        }

        return .init(pad: pad)
    }

    public func pad(request name: String) throws -> Pad {
        guard let pad = gst_element_request_pad_simple(element, name) else {
            throw ElementError.padMissing
        }

        defer {
            gst_object_unref(pad)
        }

        return .init(pad: pad)
    }

    public var bus: Bus? {
        guard let bus = gst_element_get_bus(element) else {
            return nil
        }

        return .init(bus: bus)
    }

    public func isEqual(to object: UnsafePointer<GstObject>) -> Bool {
        return element == object
    }
}

extension Element: GObjectWrapper {
    public var gObject: UnsafeMutablePointer<GObject> {
        return element.withMemoryRebound(to: GObject.self, capacity: 1) { object in
            return object
        }
    }
}
