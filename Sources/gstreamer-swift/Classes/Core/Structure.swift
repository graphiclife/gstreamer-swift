//
//  Structure.swift
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

public final class Structure {
    public let structure: UnsafeMutablePointer<GstStructure>

    public init(_ name: String) {
        self.structure = gst_structure_new_empty(name)
    }

    deinit {
        gst_structure_free(structure)
    }

    @discardableResult
    public func set(_ key: String, to value: GValueCodable) -> Self {
        set(value: value, forKey: key)
        return self
    }

    // MARK: - Private API

    private func get<T: GValueCodable>(valueForKey key: String) throws -> T? {
        guard let structureValue = gst_structure_get_value(structure, key) else {
            return nil
        }

        return try T.from(gValue: structureValue)
    }

    private func unsafeGet<T: GValueCodable>(valueForKey key: String) -> T? {
        guard let structureValue = gst_structure_get_value(structure, key) else {
            return nil
        }

        return T.unsafeFrom(gValue: structureValue)
    }

    private func set<T: GValueCodable>(value: T, forKey key: String) {
        var structureValue: GValue = .init()
        value.to(gValue: &structureValue)
        gst_structure_set_value(structure, key, &structureValue)
        g_value_unset(&structureValue)
    }
}

