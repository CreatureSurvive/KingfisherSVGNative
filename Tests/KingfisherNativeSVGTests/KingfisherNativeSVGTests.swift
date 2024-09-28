import XCTest
import Kingfisher
@testable import KingfisherNativeSVG

final class KingfisherNativeSVGTests: XCTestCase {
    func testLoadAndDecode() async throws {
        let url = URL(string: "https://img.shields.io/badge/any%20text-you%20like-blue")!
        let image = try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: .network(url), options: [.processor(SVGNativeProcessor.default)]) { result in
                switch result {
                case .success(let result):
                    print(result.image.size)
                    continuation.resume(returning: result.image)
                case .failure(let error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
        
        let temp = URL.temporaryDirectory
        #if os(macOS)
        let save = temp.appendingPathComponent("test.tiff")
        try image.tiffRepresentation?.write(to: save)
        #else
        let save = temp.appendingPathComponent("test.png")
        try image.pngData()?.write(to: save)
        #endif
        
        print(save)
    }
}
