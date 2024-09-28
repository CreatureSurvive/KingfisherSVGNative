//
//  CGImage+NativeSVG.h
//  
//
//  Created by Dana Buehre on 9/28/24.
//

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>


CF_IMPLICIT_BRIDGING_ENABLED
CF_ASSUME_NONNULL_BEGIN


__nullable CGImageRef SVGNativeImageWithString(NSString* _Nonnull string, CGSize size);

__nullable CGImageRef SVGNativeImageWithData(NSData* _Nonnull data, CGSize size);

@interface SVGNativeImageDecoder : NSObject

+ (nullable CGImageRef)decodeSVGNativeImageWithData:(NSData* _Nonnull)data;

@end

CF_ASSUME_NONNULL_END
CF_IMPLICIT_BRIDGING_DISABLED
