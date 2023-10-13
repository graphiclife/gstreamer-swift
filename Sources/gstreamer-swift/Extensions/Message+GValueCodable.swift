//
//  Message+GValueCodable.swift
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

extension Message: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Message {
        guard gValue.gValueType == gst_message_get_type() else {
            throw GValueCodableError.invalidType
        }

        guard let boxed = g_value_get_boxed(gValue) else {
            throw GValueCodableError.noValue
        }

        return boxed.withMemoryRebound(to: GstMessage.self, capacity: 1) { pointer in
            return .init(message: pointer)
        }
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, gst_message_get_type())
        g_value_set_boxed(gValue, message)
    }
}
