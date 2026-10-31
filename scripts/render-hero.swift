// Run on macOS from the profile repository root:
// swift -module-cache-path /tmp/profile-swift-cache scripts/render-hero.swift
import AppKit
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let assets = root.appendingPathComponent("assets")
let source = try String(contentsOf: assets.appendingPathComponent("hello.svg"), encoding: .utf8)
let frames = 60
let seconds = 6.0

func artwork(locale: String, frame: Int) -> String {
    var svg = source
    if locale == "zh-CN" {
        for (en, zh) in [
            ("Hello, I'm Lixiuxiu. Small ideas. Useful tools.", "你好，我是 Lixiuxiu。把小想法做成实用工具。"),
            ("A colorful maker's desk with a friendly robot, a terminal and floating geometric stickers.",
             "开发者的桌面：浮动的机器人、闪烁的终端光标与几何贴纸。"),
            ("HELLO, WORLD!", "你好，世界！"),
            ("Small ideas. Useful tools.", "把小想法做成实用工具。"),
            ("AI TOOLS / MCP / OPEN SOURCE", "AI 开发工具 / MCP / 开源项目"),
            ("MAKE IT WORK.", "有想法，就造一个。"),
        ] {
            svg = svg.replacingOccurrences(of: en, with: zh)
        }
        // The localized sticker needs more room than the short English label.
        svg = svg.replacingOccurrences(of: "font-size=\"21\"", with: "font-size=\"18\"")
        svg = svg.replacingOccurrences(of: "font-size=\"19\" letter-spacing=\"2\"",
                                       with: "font-size=\"19\" letter-spacing=\"0.5\"")
    }
    let phase = Double(frame) / Double(frames) * 2 * Double.pi
    let bob = 4 * sin(phase)
    let tilt = -8 + 1.5 * sin(phase)
    svg = svg.replacingOccurrences(of: "translate(969 199) rotate(-8)",
                                   with: "translate(969 \(199 + bob)) rotate(\(tilt))")
    svg = svg.replacingOccurrences(of: "translate(767 54) rotate(7 115 105)",
                                   with: "translate(767 \(54 - 2 * sin(phase))) rotate(7 115 105)")
    svg = svg.replacingOccurrences(of: "translate(683 266) rotate(-12)",
                                   with: "translate(683 \(266 + 2 * sin(phase))) rotate(-12)")
    // A short blink during the middle of each loop; no full-screen flashing.
    if (28...29).contains(frame) {
        svg = svg.replacingOccurrences(of: "id=\"eyes\" d=\"M45 54v9m48-9v9\"",
                                       with: "id=\"eyes\" d=\"M41 60h8m40 0h8\"")
    }
    if frame % 10 >= 5 {
        svg = svg.replacingOccurrences(of: "id=\"cursor\"", with: "id=\"cursor\" opacity=\"0\"")
    }
    return svg
}

func raster(_ svg: String) -> CGImage {
    guard let image = NSImage(data: Data(svg.utf8)),
          let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1200, pixelsHigh: 390,
                                        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
                                        isPlanar: false, colorSpaceName: .deviceRGB,
                                        bytesPerRow: 0, bitsPerPixel: 0),
          let context = NSGraphicsContext(bitmapImageRep: bitmap)
    else { fatalError("Could not render the SVG source") }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    // An opaque background avoids transparent GIF edge artifacts.
    NSColor(calibratedRed: 1, green: 0.973, blue: 0.937, alpha: 1).setFill()
    NSRect(x: 0, y: 0, width: 1200, height: 390).fill()
    image.draw(in: NSRect(x: 0, y: 0, width: 1200, height: 390))
    NSGraphicsContext.restoreGraphicsState()
    return bitmap.cgImage!
}

for locale in ["zh-CN", "en"] {
    let still = raster(artwork(locale: locale, frame: 0))
    let png = NSBitmapImageRep(cgImage: still).representation(using: .png, properties: [:])!
    try png.write(to: assets.appendingPathComponent("hello.\(locale).png"))
    let url = assets.appendingPathComponent("hello.\(locale).gif")
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.gif.identifier as CFString,
                                                            frames, nil)
    else { fatalError("Could not create GIF encoder") }
    CGImageDestinationSetProperties(destination, [kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFLoopCount: 0,
    ]] as CFDictionary)
    for frame in 0..<frames {
        autoreleasepool {
            CGImageDestinationAddImage(destination, raster(artwork(locale: locale, frame: frame)), [
                kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: seconds / Double(frames)],
            ] as CFDictionary)
        }
    }
    guard CGImageDestinationFinalize(destination) else { fatalError("Could not encode \(url.path)") }
    print("Rendered \(locale): 1200×390, \(frames) frames, \(seconds)s")
}
