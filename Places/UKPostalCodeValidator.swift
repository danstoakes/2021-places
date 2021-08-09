//
//  UKPostalCodeValidator.swift
//  Places
//
//  Created by Dan Stoakes on 07/08/2021.
//

import Foundation

private class Regex {
  let internalExpression: NSRegularExpression
  let pattern: String
  
  init(_ pattern: String) {
    self.pattern = pattern
    self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
  }
  
  func test(_ input: String) -> Bool {
    let matches = self.internalExpression.matches(in: input, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, input.count))
    return matches.count > 0
  }
}

struct UKPostalCodeValidator {
    static let pattern = "^(GIR 0AA)|((([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) [0-9][A-Z]{2})$"
    static func validate(input: String) -> Bool {
        return Regex(pattern).test(input)
    }
}
