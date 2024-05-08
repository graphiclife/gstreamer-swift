//
//  Promise.swift
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

public final class Promise {
    public let promise: UnsafeMutablePointer<GstPromise>

    public init() {
        self.promise = gst_promise_new()
    }

    public init(promise: UnsafeMutablePointer<GstPromise>) {
        self.promise = promise
        gst_promise_ref(promise)
    }

    deinit {
        gst_promise_unref(promise)
    }

    public func wait() -> GstPromiseResult {
        return gst_promise_wait(promise)
    }

    public var reply: Structure? {
        guard let reply = gst_promise_get_reply(promise) else {
            return nil
        }

        return Structure(structure: reply)
    }
}
