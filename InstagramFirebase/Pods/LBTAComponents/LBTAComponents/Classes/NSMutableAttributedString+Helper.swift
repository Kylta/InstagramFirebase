//
//  NSMutableAttributedString+Helper.swift
//  Pods
//
//  Created by Brian Voong on 11/16/16.
//
//

import Foundation

extension NSMutableAttributedString {
    
    static public func getAttributedText(_ firstText: String, _ fontFirst: UIFont, _ colorTextFirst: UIColor?, _ secondText: String, _ fontSecond: UIFont, _ colorTextSecond: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: firstText, attributes: [NSAttributedStringKey.font:fontFirst, NSAttributedStringKey.foregroundColor:colorTextFirst ?? .black])
        attributedText.append(NSAttributedString(string: secondText, attributes: [NSAttributedStringKey.font:fontSecond, NSAttributedStringKey.foregroundColor:colorTextSecond]))
        return attributedText
    }

    
    public func appendNewLine() {
        append(NSAttributedString(string: "\n"))
    }
    
    public func centerAlignWithSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = lineSpacing
        setParagraphStyle(paragraphStyle: paragraphStyle)
    }
    
    public func setLineSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        setParagraphStyle(paragraphStyle: paragraphStyle)
    }
    
    func setParagraphStyle(paragraphStyle: NSParagraphStyle) {
        let range = NSMakeRange(0, string.count)
        addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)
    }
}
