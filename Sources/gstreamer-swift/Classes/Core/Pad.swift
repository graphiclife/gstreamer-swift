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

public enum PadError: Error {
    case linkFailed
}

public final class Pad {
    public let pad: UnsafeMutablePointer<GstPad>

    public init(pad: UnsafeMutablePointer<GstPad>) {
        self.pad = pad
        gst_object_ref(pad)
    }

    deinit {
        gst_object_unref(pad)
    }

    public var name: String? {
        let name = pad.withMemoryRebound(to: GstObject.self, capacity: 1) { pointer in
            return gst_object_get_name(pointer)
        }

        guard let name else {
            return nil
        }

        defer {
            g_free(name)
        }
        
        return String(cString: name, encoding: .utf8)
    }

    @discardableResult
    public func link(to another: Pad) throws -> Self {
        if gst_pad_link(pad, another.pad) != GST_PAD_LINK_OK {
            throw PadError.linkFailed
        }

        return self
    }
}
