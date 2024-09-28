//
//  CGImage+NativeSVG.m
//
//
//  Created by Dana Buehre on 9/28/24.
//

#import "CGImage+NativeSVG.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <svgnative/SVGDocument.h>
#if __has_include(<svgnative/ports/cg/CGSVGRenderer.h>)
#include <svgnative/ports/cg/CGSVGRenderer.h>
#else
#include <svgnative/CGSVGRenderer.h>
#endif

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH || TARGET_OS_VISION
    #define IS_UIKIT 1
    #define IS_APPKIT 0
    #import <UIKit/UIKit.h>
#else
    #define IS_UIKIT 0
    #define IS_APPKIT 1
    #import <Appkit/Appkit.h>
#endif

static CGColorSpaceRef ColorSpaceForDeviceRGB(void) {
    static CGColorSpaceRef colorSpace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpace;
}

#if IS_APPKIT
static CGContextRef ContextCreateBitmapContext(CGSize size, BOOL opaque, CGFloat scale) {
    if (scale == 0) {
        NSScreen *mainScreen = nil;
        if (@available(macOS 10.12, *)) {
            mainScreen = [NSScreen mainScreen];
        } else {
            mainScreen = [NSScreen screens].firstObject;
        }
        scale = mainScreen.backingScaleFactor ?: 1.0f;
    }
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    if (width < 1 || height < 1) return NULL;
    
    CGColorSpaceRef space = ColorSpaceForDeviceRGB();
    CGBitmapInfo bitmapInfo;
    if (!opaque) {
        bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    } else {
        bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast;
    }
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
    if (!context) {
        return NULL;
    }
    CGContextScaleCTM(context, scale, scale);
    
    return context;
}
#endif

static void BeginImageContext(CGSize size, BOOL opaque, CGFloat scale) {
#if IS_UIKIT
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
#else
    CGContextRef context = ContextCreateBitmapContext(size, opaque, scale);
    if (!context) {
        return;
    }
    NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithCGContext:context flipped:NO];
    CGContextRelease(context);
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext.currentContext = graphicsContext;
#endif
}

void EndImageContext(void) {
#if IS_UIKIT
    UIGraphicsEndImageContext();
#else
    [NSGraphicsContext restoreGraphicsState];
#endif
}

CGContextRef GetCurrentContext(void) {
#if IS_UIKIT
    return UIGraphicsGetCurrentContext();
#else
    return NSGraphicsContext.currentContext.CGContext;
#endif
}
    
__nullable CGImageRef SVGNativeImageWithString(NSString* _Nonnull string, CGSize size) {
    
    auto renderer = std::make_shared<SVGNative::CGSVGRenderer>();
    
    auto doc = SVGNative::SVGDocument::CreateSVGDocument([string UTF8String], renderer).release();
    if (!doc) {
        return nil;
    }
    
    CGSize svgSize = size;
    if (CGSizeEqualToSize(svgSize, CGSizeZero)) {
        svgSize = CGSizeMake(doc->Width(), doc->Height());
    }
    
    BeginImageContext(svgSize, NO, 1.0f);
    CGContextRef ctx = GetCurrentContext();
    
    renderer->SetGraphicsContext(ctx);
    
#if TARGET_OS_OSX
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -svgSize.height);
#endif
    
    doc->Render(svgSize.width, svgSize.height);
    
    renderer->ReleaseGraphicsContext();
    CGImageRef image = CGBitmapContextCreateImage(GetCurrentContext());
    EndImageContext();
    
    return image;
}

__nullable CGImageRef SVGNativeImageWithData(NSData* _Nonnull data, CGSize size) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!string) {
        return NULL;
    }
    
    return SVGNativeImageWithString(string, size);
}

@implementation SVGNativeImageDecoder

+ (nullable CGImageRef)decodeSVGNativeImageWithData:(NSData* _Nonnull)data {
    return SVGNativeImageWithData(data, CGSizeZero);
}

@end
