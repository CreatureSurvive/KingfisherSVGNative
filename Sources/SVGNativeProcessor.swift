//
//  SVGNativeProcessor.swift
//
//
//  Created by Dana Buehre on 9/29/24.
//

import Foundation
import Kingfisher

public struct SVGNativeProcessor: ImageProcessor {
    public static let `default` = SVGNativeProcessor()
    
    public var identifier: String = "com.creaturecoding.svg-native-processor"
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            if data.isSVGFormat {
                return KingfisherWrapper.decodeSVGNative(data: data)
            } else {
                return DefaultImageProcessor.default.process(item: item, options: options)
            }
        }
    }
}
