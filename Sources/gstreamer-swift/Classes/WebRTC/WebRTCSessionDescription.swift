//
//  WebRTCSessionDescription.swift
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
import gstreamer_sdp
import gstreamer_webrtc

public final class WebRTCSessionDescription {
    public enum WebRTCSessionDescriptionError: Error {
        case parseFailed
    }

    public let sessionDescription: UnsafeMutablePointer<GstWebRTCSessionDescription>

    public init(sessionDescription: UnsafeMutablePointer<GstWebRTCSessionDescription>) {
        self.sessionDescription = gst_webrtc_session_description_copy(sessionDescription)
    }

    public init(type: GstWebRTCSDPType, sdp: String) throws {
        var sdpMessage: UnsafeMutablePointer<GstSDPMessage>?

        guard let buffer = sdp.cString(using: .utf8) else {
            throw WebRTCSessionDescriptionError.parseFailed
        }

        if gst_sdp_message_new_from_text(buffer, &sdpMessage) != GST_SDP_OK {
            throw WebRTCSessionDescriptionError.parseFailed
        }

        self.sessionDescription = gst_webrtc_session_description_new(type, sdpMessage)
    }

    deinit {
        gst_webrtc_session_description_free(sessionDescription)
    }

    public var sdp: String? {
        guard let sdp = sessionDescription.pointee.sdp else {
            return nil
        }

        guard let sdpText = gst_sdp_message_as_text(sdp) else {
            return nil
        }

        defer {
            g_free(sdpText)
        }

        return String(cString: sdpText, encoding: .utf8)
    }
}
