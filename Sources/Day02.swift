import Foundation
import Parsing

final class Day02: AdventDay {
  let ranges: [(Int, Int)]

  init(data: String) {
    var allRanges: [(Int, Int)] = []
    var modifiableData = data[...]

    let range = Parse(input: Substring.self) {
      Int.parser()
      "-"
      Int.parser()
    }
    let completeParser = Many(element: { range },
                              separator: { "," })
    do {
      allRanges = try completeParser.parse(&modifiableData)
    } catch {
      print("Parsing of input data failed!")
    }

    ranges = allRanges
  }

  func isInvalidID(_ subject: Int) -> Bool {
    // turn it into a string
    let subjectString = String(subject)
    
    // does the string consist of exactly two identical sequences?
    guard subjectString.count % 2 == 0  else {
      // an odd number of digits can't be a doubled string
      return false
    }
    let firstHalf = subjectString.prefix(subjectString.count / 2)
    let secondHalf = subjectString.suffix(subjectString.count / 2)
    return firstHalf == secondHalf
  }

  func part1() -> Any {
    var accumulatedIDs = 0
    for (lower, upper) in ranges {
      for candidate in lower...upper {
        if isInvalidID(candidate) {
          accumulatedIDs += candidate
        }
      }
    }
    return "\(accumulatedIDs)"
  }

  func part2() -> Any {
    var accumulatedIDs = 0
    for (lower, upper) in ranges {
      for candidate in lower...upper {
        if isReallyInvalidID(candidate) {
          accumulatedIDs += candidate
        }
      }
    }
    return "\(accumulatedIDs)"
  }

  func isReallyInvalidID(_ subject: Int) -> Bool {
    let subjectString = String(subject)
    let midpoint: Int = subjectString.count / 2
    guard midpoint >= 1 else { return false }
    for prefixCount in 1...midpoint {
      let prefix = subjectString.prefix(prefixCount)
      if isPrefixRepeatedToFill(prefix: prefix, fullString: subjectString) {
        return true
      }
    }
    return false
  }

  func isPrefixRepeatedToFill(prefix: Substring, fullString: String) -> Bool {
    var modifiableString = fullString[...]
    let prefixParser = Parse(input: Substring.self) {
      "\(prefix)"
    }
    while !modifiableString.isEmpty {
      do {
        try prefixParser.parse(&modifiableString)
      } catch {
        // well, that failed. so, we'll say it's a no
        return false
      }
    }
    return true
  }
}
