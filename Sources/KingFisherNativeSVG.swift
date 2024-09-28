//
//  KingfisherNativeSVG.swift
//
//
//  Created by Dana Buehre on 9/28/24.
//

import Foundation
import Kingfisher
import KingfisherNativeSVGObjc

#if SWIFT_PACKAGE
import KingfisherNativeSVGObjc
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif


extension KingfisherWrapper where Base: KFCrossPlatformImage {
    static func decodeSVGNative(data: Data) -> KFCrossPlatformImage? {
        if let ref = SVGNativeImageDecoder.decodeSVGNativeImage(with: data)?.takeRetainedValue() {
            #if os(macOS)
            return KFCrossPlatformImage(cgImage: ref, size: CGSize(width: ref.width, height: ref.height))
            #else
            return KFCrossPlatformImage(cgImage: ref)
            #endif
        }
        return nil
    }
}

extension Data {
    var isSVGFormat: Bool {
        guard let tag = "</svg>".data(using: .utf8) else { return false }
        return range(of: tag, options: .backwards, in: self.index(endIndex, offsetBy: -(Swift.min(100, count - 1)))..<self.endIndex) != nil
    }
}
