//
//  Int+GValueCodable.swift
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

extension Int8: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Int8 {
        guard gValue.gValueType == G_TYPE_W_CHAR else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_schar(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_CHAR)
        g_value_set_schar(gValue, self)
    }
}

extension UInt8: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> UInt8 {
        guard gValue.gValueType == G_TYPE_W_UCHAR else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_uchar(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_UCHAR)
        g_value_set_uchar(gValue, self)
    }
}

extension Int32: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Int32 {
        guard gValue.gValueType == G_TYPE_W_INT else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_int(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_INT)
        g_value_set_int(gValue, self)
    }
}

extension UInt32: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> UInt32 {
        guard gValue.gValueType == G_TYPE_W_UINT else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_uint(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_UINT)
        g_value_set_uint(gValue, self)
    }
}

extension Int: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Int {
        guard gValue.gValueType == G_TYPE_W_LONG else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_long(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_LONG)
        g_value_set_long(gValue, self)
    }
}

extension UInt: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> UInt {
        guard gValue.gValueType == G_TYPE_W_ULONG else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_ulong(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_ULONG)
        g_value_set_ulong(gValue, self)
    }
}

extension Int64: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> Int64 {
        guard gValue.gValueType == G_TYPE_W_INT64 else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_int64(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_INT64)
        g_value_set_int64(gValue, self)
    }
}

extension UInt64: GValueCodable {
    public static func from(gValue: UnsafePointer<GValue>) throws -> UInt64 {
        guard gValue.gValueType == G_TYPE_W_UINT64 else {
            throw GValueCodableError.invalidType
        }

        return g_value_get_uint64(gValue)
    }

    public func to(gValue: UnsafeMutablePointer<GValue>) {
        g_value_unset(gValue)
        g_value_init(gValue, G_TYPE_W_UINT64)
        g_value_set_uint64(gValue, self)
    }
}
