//
//  SignalMarshal.swift
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

class Marshal {
    private static let closureMarshal: GClosureMarshal = { closure, returnValue, nParamValues, paramValues, invocationHint, marshalData in
        guard let marshalData else {
            return
        }

        var values: [UnsafePointer<GValue>]

        if let paramValues, nParamValues > 0 {
            values = Array(stride(from: paramValues, to: paramValues + Int(nParamValues), by: 1))
        } else {
            values = []
        }

        Unmanaged<Marshal>
            .fromOpaque(marshalData)
            .takeUnretainedValue()
            .call(paramValues: values, returnValue: returnValue)
    }

    private static let closureFinalize: GClosureNotify = { notifyData, closure in
        guard let notifyData else {
            return
        }
        
        Unmanaged<Marshal>
            .fromOpaque(notifyData)
            .release()
    }

    enum MarshalError: Error {
        case closureAllocationFailed
    }

    typealias Handler = ([UnsafePointer<GValue>], UnsafeMutablePointer<GValue>?) -> Void

    static func closure(for handler: @escaping Handler) throws -> UnsafeMutablePointer<GClosure> {
        guard let closure = g_closure_new_simple(UInt32(MemoryLayout<GClosure>.size), nil) else {
            throw MarshalError.closureAllocationFailed
        }

        let marshal = Marshal(handler)
        marshal.attach(to: closure)
        return closure
    }

    let marshal: Handler

    init(_ marshal: @escaping Handler) {
        self.marshal = marshal
    }

    private func attach(to closure: UnsafeMutablePointer<GClosure>) {
        let reference = Unmanaged.passRetained(self).toOpaque()

        g_closure_set_meta_marshal(closure, reference, Self.closureMarshal)
        g_closure_add_finalize_notifier(closure, reference, Self.closureFinalize)
    }

    private func call(paramValues: [UnsafePointer<GValue>], returnValue: UnsafeMutablePointer<GValue>?) {
        marshal(paramValues, returnValue)
    }
}
