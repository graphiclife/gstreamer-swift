//
//  Caps.swift
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

public final class Caps {
    public class Builder {
        private var structures = [Structure]()

        public init() {
        }

        public func begin(mediaType: String) -> Self {
            structures.append(.init(mediaType))
            return self
        }

        public func set(_ key: String, to value: GValueCodable) -> Self {
            structures[structures.count - 1].set(key, to: value)
            return self
        }

        public func build() -> Caps {
            return .init(structures: structures)
        }
    }

    public static func any() -> Caps {
        let caps: UnsafeMutablePointer<GstCaps> = gst_caps_new_any()

        defer {
            gst_caps_unref(caps)
        }

        return .init(caps: caps)
    }

    public static func empty(mediaType: String) -> Caps {
        let caps: UnsafeMutablePointer<GstCaps> = gst_caps_new_empty_simple(mediaType)

        defer {
            gst_caps_unref(caps)
        }

        return .init(caps: caps)
    }

    public let caps: UnsafeMutablePointer<GstCaps>

    public init(caps: UnsafePointer<GstCaps>) {
        self.caps = gst_caps_copy(caps)
    }

    public init(caps: UnsafeMutablePointer<GstCaps>) {
        self.caps = caps
        gst_caps_ref(caps)
    }

    public init (structures: [Structure]) {
        self.caps = gst_caps_new_empty()

        structures.forEach { structure in
            gst_caps_append_structure(caps, gst_structure_copy(structure.structure))
        }
    }

    deinit {
        gst_caps_unref(caps)
    }
}

extension Caps: CustomStringConvertible {
    public var description: String {
        guard let string = gst_caps_to_string(caps) else {
            return "[Caps]"
        }

        defer {
            g_free(string)
        }

        return "\(string)"
    }
}
