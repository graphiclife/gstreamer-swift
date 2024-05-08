//
//  GValueCodable+Test.swift
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

import XCTest
import gstreamer

@testable import gstreamer_swift

final class GValueCodable_Test: XCTestCase {
    func testBool() throws {
        var gvalue: GValue = .init()
        let value: Bool = true

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_BOOLEAN)
        XCTAssertEqual(try Bool.from(gValue: &gvalue), value)
    }

    func testInt8() throws {
        var gvalue: GValue = .init()
        let value: Int8 = Int8.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_CHAR)
        XCTAssertEqual(try Int8.from(gValue: &gvalue), value)
    }

    func testUInt8() throws {
        var gvalue: GValue = .init()
        let value: UInt8 = UInt8.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_UCHAR)
        XCTAssertEqual(try UInt8.from(gValue: &gvalue), value)
    }

    func testInt32() throws {
        var gvalue: GValue = .init()
        let value: Int32 = Int32.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_INT)
        XCTAssertEqual(try Int32.from(gValue: &gvalue), value)
    }

    func testUInt32() throws {
        var gvalue: GValue = .init()
        let value: UInt32 = UInt32.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_UINT)
        XCTAssertEqual(try UInt32.from(gValue: &gvalue), value)
    }

    func testInt() throws {
        var gvalue: GValue = .init()
        let value: Int = Int.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_LONG)
        XCTAssertEqual(try Int.from(gValue: &gvalue), value)
    }

    func testUInt() throws {
        var gvalue: GValue = .init()
        let value: UInt = UInt.max

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_ULONG)
        XCTAssertEqual(try UInt.from(gValue: &gvalue), value)
    }

    func testFloat() throws {
        var gvalue: GValue = .init()
        let value: Float = Float.greatestFiniteMagnitude

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_FLOAT)
        XCTAssertEqual(try Float.from(gValue: &gvalue), value)
    }

    func testDouble() throws {
        var gvalue: GValue = .init()
        let value: Double = Double.greatestFiniteMagnitude

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_DOUBLE)
        XCTAssertEqual(try Double.from(gValue: &gvalue), value)
    }

    func testString() throws {
        var gvalue: GValue = .init()
        let value: String = "abcABC💚🌟 \t\n\rÅÄÖåäö"

        value.to(gValue: &gvalue)

        XCTAssertEqual(gvalue.g_type, G_TYPE_W_STRING)
        XCTAssertEqual(try String.from(gValue: &gvalue), value)
    }
}
