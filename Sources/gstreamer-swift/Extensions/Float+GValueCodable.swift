//
//  Float+GValueCodable.swift
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

extension Float: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Float {
        guard gValue.gValueType == G_TYPE_W_FLOAT else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_float(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_FLOAT)
        g_value_set_float(gValue, self)
    }
}

extension Double: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Double {
        guard gValue.gValueType == G_TYPE_W_DOUBLE else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_double(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_DOUBLE)
        g_value_set_double(gValue, self)
    }
}
