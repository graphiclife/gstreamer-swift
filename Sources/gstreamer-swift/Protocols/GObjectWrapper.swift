//
//  GObjectWrapper.swift
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

public enum GObjectWrapperError: Error {
    case memoryAllocationFailed
    case invalidSignal
}

public protocol GObjectWrapper: GValueCodable, AnyObject {
    var gObject: UnsafeMutablePointer<GObject> { get }
}

// MARK: - Properties

extension GObjectWrapper {
    public func get<T: GValueCodable>(valueForKey key: String) throws -> T {
        var propertyValue: GValue = .init()
        g_object_get_property(gObject, key, &propertyValue)
        let value: T = try T.from(gValue: &propertyValue)
        g_value_unset(&propertyValue)
        return value
    }

    public func unsafeGet<T: GValueCodable>(valueForKey key: String) -> T {
        var propertyValue: GValue = .init()
        g_object_get_property(gObject, key, &propertyValue)
        let value: T = T.unsafeFrom(gValue: &propertyValue)
        g_value_unset(&propertyValue)
        return value
    }

    public func set<T: GValueCodable>(value: T, forKey key: String) {
        var propertyValue: GValue = .init()
        value.to(gValue: &propertyValue)
        g_object_set_property(gObject, key, &propertyValue)
        g_value_unset(&propertyValue)
    }

    public func remove(valueForKey key: String) {
        let property = g_object_class_find_property(g_object_w_get_class(gObject), key)
        let value = g_param_spec_get_default_value(property)
        g_object_set_property(gObject, key, value)
    }

    public subscript<T>(key: String) -> T where T: GValueCodable {
        get {
            unsafeGet(valueForKey: key)
        }
        set(newValue) {
            set(value: newValue, forKey: key)
        }
    }
}

// MARK: - Signals

extension GObjectWrapper {
    @discardableResult
    public func connect(signal: String, handler: @escaping () -> Void) throws -> UInt {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler()
        }), 0)
    }

    @discardableResult
    public func connect<A>(signal: String, handler: @escaping (A) -> Void) throws -> UInt where A: GValueDecodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]))
        }), 0)
    }

    @discardableResult
    public func connect<A, B>(signal: String, handler: @escaping (A, B) -> Void) throws -> UInt where A: GValueDecodable, B: GValueDecodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]))
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C>(signal: String, handler: @escaping (A, B, C) -> Void) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]),
                    C.unsafeFrom(gValue: paramValues[2]))
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C, D>(signal: String, handler: @escaping (A, B, C, D) -> Void) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable, D: GValueDecodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]),
                    C.unsafeFrom(gValue: paramValues[2]),
                    D.unsafeFrom(gValue: paramValues[3]))
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C, D, E>(signal: String, handler: @escaping (A, B, C, D, E) -> Void) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable, D: GValueDecodable, E: GValueDecodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]),
                    C.unsafeFrom(gValue: paramValues[2]),
                    D.unsafeFrom(gValue: paramValues[3]),
                    E.unsafeFrom(gValue: paramValues[4]))
        }), 0)
    }

    @discardableResult
    public func connect<R>(signal: String, handler: @escaping () -> R) throws -> UInt where R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler().unsafeTo(gValue: returnValue)
        }), 0)
    }

    @discardableResult
    public func connect<A, R>(signal: String, handler: @escaping (A) -> R) throws -> UInt where A: GValueDecodable, R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0])).unsafeTo(gValue: returnValue)
        }), 0)
    }

    @discardableResult
    public func connect<A, B, R>(signal: String, handler: @escaping (A, B) -> R) throws -> UInt where A: GValueDecodable, B: GValueDecodable, R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1])).unsafeTo(gValue: returnValue)
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C, R>(signal: String, handler: @escaping (A, B, C) -> R) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable, R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]),
                    C.unsafeFrom(gValue: paramValues[2])).unsafeTo(gValue: returnValue)
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C, D, R>(signal: String, handler: @escaping (A, B, C, D) -> R) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable, D: GValueDecodable, R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                    B.unsafeFrom(gValue: paramValues[1]),
                    C.unsafeFrom(gValue: paramValues[2]),
                    D.unsafeFrom(gValue: paramValues[3])).unsafeTo(gValue: returnValue)
        }), 0)
    }

    @discardableResult
    public func connect<A, B, C, D, E, R>(signal: String, handler: @escaping (A, B, C, D, E) -> R) throws -> UInt where A: GValueDecodable, B: GValueDecodable, C: GValueDecodable, D: GValueDecodable, E: GValueDecodable, R: GValueEncodable {
        return g_signal_connect_closure(gObject, signal, try Marshal.closure(for: { paramValues, returnValue in
            handler(A.unsafeFrom(gValue: paramValues[0]),
                            B.unsafeFrom(gValue: paramValues[1]),
                            C.unsafeFrom(gValue: paramValues[2]),
                            D.unsafeFrom(gValue: paramValues[3]),
                            E.unsafeFrom(gValue: paramValues[4])).unsafeTo(gValue: returnValue)
        }), 0)
    }

    public func disconnect(signalHandlerId: UInt) {
        g_signal_handler_disconnect(gObject, signalHandlerId)
    }

    public func send(_ signal: String, params: [GValueCodable]) throws {
        var sender: GValue = .init()
        self.to(gValue: &sender)

        var values: [GValue] = params.map {
            var value: GValue = .init()
            $0.to(gValue: &value)
            return value
        }

        values.insert(sender, at: 0)

        return try values.withUnsafeBufferPointer { pointer in
            guard let values = pointer.baseAddress else {
                throw GObjectWrapperError.memoryAllocationFailed
            }

            let signal = g_signal_lookup(signal, g_type_w_get_from_class(g_object_w_get_class(gObject)))

            guard signal > 0 else {
                throw GObjectWrapperError.invalidSignal
            }

            g_signal_emitv(values, signal, 0, nil)
        }
    }

    @discardableResult
    public func send<T: GValueCodable>(_ signal: String, params: [GValueCodable]) throws -> T {
        var sender: GValue = .init()
        self.to(gValue: &sender)

        var values: [GValue] = params.map {
            var value: GValue = .init()
            $0.to(gValue: &value)
            return value
        }

        values.insert(sender, at: 0)

        return try values.withUnsafeBufferPointer { pointer in
            guard let values = pointer.baseAddress else {
                throw GObjectWrapperError.memoryAllocationFailed
            }

            let signal = g_signal_lookup(signal, g_type_w_get_from_class(g_object_w_get_class(gObject)))

            guard signal > 0 else {
                throw GObjectWrapperError.invalidSignal
            }

            var result: GValue = .init()
            g_signal_emitv(values, signal, 0, &result)
            return try T.from(gValue: &result)
        }
    }
}
