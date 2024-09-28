# KingfisherNativeSVG

KingfisherNativeSVG is an extension for [Kingfisher](https://github.com/onevcat/Kingfisher) that provides an `ImageProcessor` and `CacheSerializer` for loading and saving images in the [SVG Native Format](https://svgwg.org/specs/svg-native/).

## Usage:

```swift
let url = URL(string: "url/of/your/svg/image")
imageView.kf.setImage(with: url, options: [.processor(SVGNativeProcessor.default), .cacheSerializer(SVGNativeSerializer.default)])
```

You can also set it as a global default for Kingfisher

```swift
KingfisherManager.shared.defaultOptions += [
  .processor(SVGNativeProcessor.default),
  .cacheSerializer(SVGNativeSerializer.default)
]

imageView.kf.setImage(with: url)
```

## Installation

KingfisherSVGNative is available through [Swift Package Manager](https://swift.org/package-manager).

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/CreatureSurvive/KingfisherSVGNative", from: "0.1.0")
    ],
    // ...
)
```

## Depends

[svgnative-Xcode](https://github.com/SDWebImage/svgnative-Xcode)

## Author

[CreatureSurvive](https://github.com/CreatureSurvive) 

## Reference:

[KingfisherWebP](https://github.com/yeatse/KingfisherWebP)
[SDWebImageSVGNativeCoder](https://github.com/SDWebImage/SDWebImageSVGNativeCoder)

## License

KingfisherSVGNative is available under the MIT license. See the LICENSE file for more info.
