//
//  Copyright 2026 Readium Foundation. All rights reserved.
//  Use of this source code is governed by the BSD-style license
//  available in the top-level LICENSE file of the project.
//

import Foundation

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit

    public typealias UIImage = NSImage
    public typealias UIColor = NSColor

    extension NSImage {
        public convenience init?(cgImage: CGImage) {
            let size = NSSize(width: cgImage.width, height: cgImage.height)
            self.init(cgImage: cgImage, size: size)
        }

        public func pngData() -> Data? {
            guard let tiffData = tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData)
            else {
                return nil
            }
            return bitmap.representation(using: .png, properties: [:])
        }

        public func scaleToFit(maxSize: CGSize) -> NSImage {
            if size.width <= maxSize.width, size.height <= maxSize.height {
                return self
            }

            let widthRatio = maxSize.width / size.width
            let heightRatio = maxSize.height / size.height
            let ratio = min(widthRatio, heightRatio)
            let targetSize = NSSize(width: size.width * ratio, height: size.height * ratio)

            let newImage = NSImage(size: targetSize)
            newImage.lockFocus()
            draw(in: NSRect(origin: .zero, size: targetSize),
                 from: NSRect(origin: .zero, size: size),
                 operation: .copy,
                 fraction: 1.0)
            newImage.unlockFocus()
            return newImage
        }
    }
#endif
