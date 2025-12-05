import Foundation
import Parsing

final class Day05: AdventDay {
  let freshRanges: [ClosedRange<Int>]
  let ingredients: [Int]

  init(data: String) {
    let rangesParser = Many(element: { Parse(input: Substring.self) {
      Int.parser()
      "-"
      Int.parser()
    }.map { $0...$1 } },
                            separator: { "\n" },
                            terminator: { "\n\n" })
    let ingredientsParser = Many(element: { Parse(input: Substring.self) { Int.parser() } },
                                 separator: { "\n" })
    let dataParser = Parse(input: Substring.self) {
      rangesParser
      ingredientsParser
    }
    var theInput = data[...]
    do {
      let (ranges, ingredientsData) = try dataParser.parse(&theInput)
      freshRanges = ranges
      ingredients = ingredientsData
    } catch {
      print("Parsing failed! \(error.localizedDescription)")
      freshRanges = []
      ingredients = []
    }
  }

  // we're supposed to count how many ingredients fall within at least one range
  func part1() -> Any {
    var freshCount: Int = 0
    let freshDB = DiscontinuousRange()
    for range in freshRanges {
      freshDB.add(range: range)
    }
    for ingredient in ingredients {
//      if isFresh(ingredient) { freshCount += 1 }
      if freshDB.contains(ingredient) { freshCount += 1 }
    }
    return "\(freshCount)"
  }

  func isFresh(_ ingredient: Int) -> Bool {
    for range in freshRanges {
      if range.contains(ingredient) {
        return true
      }
    }
    return false
  }

  // so now, we just want to know the count of possible fresh ids
  func part2() -> Any {
    let freshDB = DiscontinuousRange()
    for range in freshRanges {
      freshDB.add(range: range)
    }
    return "\(freshDB.count())"
  }

}

extension ClosedRange {
  func combined(with other: ClosedRange) -> ClosedRange {
    let minValue = Swift.min(self.lowerBound, other.lowerBound)
    let maxValue = Swift.max(self.upperBound, other.upperBound)
    return minValue...maxValue
  }
}

class DiscontinuousRange {
  var ranges: [ClosedRange<Int>]

  init() {
    ranges = []
  }

  func remove(range: ClosedRange<Int>) {
    ranges.removeAll(where: { $0 == range })
  }

  func add(range: ClosedRange<Int>) {
    var overlappingRanges: [ClosedRange<Int>] = []
    for existingRange in ranges {
      if existingRange.overlaps(range) {
        overlappingRanges.append(existingRange)
      }
    }
    ranges.removeAll(where: { overlappingRanges.contains($0) })
    var combinedRange = range
    for overlap in overlappingRanges {
      combinedRange = combinedRange.combined(with: overlap)
    }
    ranges.append(combinedRange)
  }

  func contains(_ element: Int) -> Bool {
    for range in ranges {
      if range.contains(element) { return true }
    }
    return false
  }

  func count() -> Int {
    ranges.reduce(0, { $0 + (($1.upperBound + 1) - $1.lowerBound) })
  }
}
