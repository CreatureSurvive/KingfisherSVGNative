//
//  SVGNativeSerializer.swift
//
//
//  Created by Dana Buehre on 9/29/24.
//

import Foundation
import Kingfisher

public struct SVGNativeSerializer: CacheSerializer {
    public static let `default` = SVGNativeSerializer()
    
    /// Whether the image should be serialized in a lossy format. Default is false.
    public var isLossy: Bool = false
    
    /// The compression quality when converting image to a lossy format data. Default is 1.0.
    public var compressionQuality: CGFloat = 1.0
    
    /// See ```CacheSerializer/originalDataUsed```
    public var originalDataUsed: Bool = true
    
    private init() {}
    
    public func data(with image: KFCrossPlatformImage, original: Data?) -> Data? {
        if originalDataUsed {
            if let original = original {
                return original
            }
        }
        if let original = original, !original.isSVGFormat {
            return DefaultCacheSerializer.default.data(with: image, original: original)
        }
        return nil
    }
    
    public func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        return SVGNativeProcessor.default.process(item: .data(data), options: options)
    }
}
