#!/usr/bin/env swift
//
// Generate Mac terminal theme files from in-repo palettes.
//
//   Terminal.app  → mac/themes/gas-city-twilight.terminal
//   iTerm2        → mac/themes/gas-city-dawn.itermcolors
//
// Run from the repo root:
//   swift scripts/generate-mac-themes.swift
//
// Both palettes are warm-dark / warm-light siblings of the Alacritty
// "Gas City" theme defined in mac/.alacritty.toml.

import Foundation
import AppKit

struct Palette {
    let name: String
    let background: String
    let foreground: String
    let cursor: String
    let selection: String
    let ansi: [String]   // 16 entries: 0–7 normal, 8–15 bright
    let fontName: String   // PostScript name, e.g. "JetBrainsMonoNerdFont-Regular"
    let fontSize: CGFloat
}

func rgba(_ hex: String) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
    var s = hex
    if s.hasPrefix("#") { s.removeFirst() }
    var v: UInt64 = 0
    Scanner(string: s).scanHexInt64(&v)
    return (
        CGFloat((v >> 16) & 0xff) / 255.0,
        CGFloat((v >>  8) & 0xff) / 255.0,
        CGFloat( v        & 0xff) / 255.0,
        1.0
    )
}

func encodeColor(_ hex: String) -> Data {
    let (r, g, b, a) = rgba(hex)
    let c = NSColor(srgbRed: r, green: g, blue: b, alpha: a)
    return try! NSKeyedArchiver.archivedData(withRootObject: c, requiringSecureCoding: false)
}

func encodeFont(_ name: String, size: CGFloat) -> Data {
    guard let f = NSFont(name: name, size: size) else {
        fatalError("font not found: \(name) — install JetBrainsMono Nerd Font")
    }
    return try! NSKeyedArchiver.archivedData(withRootObject: f, requiringSecureCoding: false)
}

func colorDict(_ hex: String) -> [String: Any] {
    let (r, g, b, a) = rgba(hex)
    return [
        "Color Space":     "sRGB",
        "Red Component":   Double(r),
        "Green Component": Double(g),
        "Blue Component":  Double(b),
        "Alpha Component": Double(a),
    ]
}

func writeTerminalApp(_ p: Palette, to path: String) throws {
    let ansiKeys = [
        "ANSIBlackColor", "ANSIRedColor", "ANSIGreenColor", "ANSIYellowColor",
        "ANSIBlueColor", "ANSIMagentaColor", "ANSICyanColor", "ANSIWhiteColor",
        "ANSIBrightBlackColor", "ANSIBrightRedColor", "ANSIBrightGreenColor",
        "ANSIBrightYellowColor", "ANSIBrightBlueColor", "ANSIBrightMagentaColor",
        "ANSIBrightCyanColor", "ANSIBrightWhiteColor",
    ]
    var plist: [String: Any] = [
        "name":                  p.name,
        "type":                  "Window Settings",
        "ProfileCurrentVersion": 2.07,
        "BackgroundColor":       encodeColor(p.background),
        "TextColor":             encodeColor(p.foreground),
        "TextBoldColor":         encodeColor(p.foreground),
        "SelectionColor":        encodeColor(p.selection),
        "CursorColor":           encodeColor(p.cursor),
        "Font":                  encodeFont(p.fontName, size: p.fontSize),
    ]
    for (i, key) in ansiKeys.enumerated() {
        plist[key] = encodeColor(p.ansi[i])
    }
    let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    try data.write(to: URL(fileURLWithPath: path))
}

func writeITermColors(_ p: Palette, to path: String) throws {
    var plist: [String: Any] = [:]
    for i in 0..<16 {
        plist["Ansi \(i) Color"] = colorDict(p.ansi[i])
    }
    plist["Background Color"]   = colorDict(p.background)
    plist["Foreground Color"]   = colorDict(p.foreground)
    plist["Bold Color"]         = colorDict(p.foreground)
    plist["Cursor Color"]       = colorDict(p.cursor)
    plist["Cursor Text Color"]  = colorDict(p.background)
    plist["Selection Color"]    = colorDict(p.selection)
    plist["Selected Text Color"] = colorDict(p.foreground)
    plist["Link Color"]         = colorDict(p.ansi[4])
    plist["Badge Color"]        = colorDict(p.ansi[1])
    let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    try data.write(to: URL(fileURLWithPath: path))
}

// Both terminals use the JetBrainsMono Nerd Font Mono variant. The "Mono"
// suffix forces nerd-font glyphs to a fixed cell width so prompt icons,
// git status symbols, etc. don't break column alignment.
let nerdFont = "JetBrainsMonoNFM-Regular"

let twilight = Palette(
    name:       "Gas City Twilight",
    background: "#5c3e22",
    foreground: "#f5e2b8",
    cursor:     "#e8a868",
    selection:  "#7a5638",
    ansi: [
        "#3a2818", "#d9824a", "#95a566", "#e8a868",
        "#6890b0", "#cf8a78", "#8ab2b2", "#f5e2b8",
        "#7a5638", "#ec9460", "#b3c280", "#f5c078",
        "#88b0d0", "#e0a89a", "#a8ccca", "#fff0d0",
    ],
    fontName: nerdFont,
    fontSize: 22
)

// Gas City Espresso — sits between Alacritty's deep walnut (#1e150e) and
// Terminal's chocolate Twilight (#5c3e22). Dark, but distinct from both.
let espresso = Palette(
    name:       "Gas City Espresso",
    background: "#2e1e10",
    foreground: "#e8d4a8",
    cursor:     "#e0a060",
    selection:  "#4a3220",
    ansi: [
        "#1e150e", "#cc6e3a", "#8a9a5b", "#e0a060",
        "#5b85a8", "#c4806c", "#7fa9a9", "#e8d4a8",
        "#3d2e20", "#e08652", "#a8b878", "#f0b870",
        "#7ba5c8", "#d8a090", "#9fc4c4", "#fce8c8",
    ],
    fontName: nerdFont,
    fontSize: 18
)

let outDir = ProcessInfo.processInfo.environment["DOTFILES_THEMES_DIR"]
    ?? FileManager.default.currentDirectoryPath + "/mac/themes"

try FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

let twilightPath = "\(outDir)/gas-city-twilight.terminal"
let espressoPath = "\(outDir)/gas-city-espresso.itermcolors"

try writeTerminalApp(twilight, to: twilightPath)
try writeITermColors(espresso, to: espressoPath)

print("wrote \(twilightPath)")
print("wrote \(espressoPath)")
