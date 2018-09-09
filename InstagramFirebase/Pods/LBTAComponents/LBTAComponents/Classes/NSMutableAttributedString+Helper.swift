//
//  NSMutableAttributedString+Helper.swift
//  Pods
//
//  Created by Brian Voong on 11/16/16.
//
//

import Foundation

extension NSMutableAttributedString {
    
    static public func getAttributedText(topText: String, bottomText: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: topText, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: bottomText, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
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
