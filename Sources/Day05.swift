import Foundation
import Parsing
import QBStructures


final class Day05: AdventDay {
  let theRanges: DiscontinuousRange<Int>
  let ingredients: [Int]

  init(data: String) {
    let rangesParser = Many(element: { Parse(input: Substring.self) {
      Int.parser()
      "-"
      Int.parser()
    }.map { Range($0...$1) } },
                            separator: { "\n" },
                            terminator: { "\n\n" })
    let ingredientsParser = Many(element: { Parse(input: Substring.self) { Int.parser() } },
                                 separator: { "\n" })
    let dataParser = Parse(input: Substring.self) {
      rangesParser
      ingredientsParser
    }
    var theInput = data[...]
    var ranges: [Range<Int>]
    do {
      let (parsedRanges, ingredientsData) = try dataParser.parse(&theInput)
      ranges = parsedRanges
      ingredients = ingredientsData
    } catch {
      print("Parsing failed! \(error.localizedDescription)")
      ingredients = []
      ranges = []
    }
    var accumulatedRanges = DiscontinuousRange<Int>()
    for range in ranges {
      accumulatedRanges.add(range: range)
    }
    theRanges = accumulatedRanges
  }

  // we're supposed to count how many ingredients fall within at least one range
  func part1() -> Any {
    var freshCount: Int = 0
    for ingredient in ingredients {
      if theRanges.contains(ingredient) { freshCount += 1 }
    }
    return "\(freshCount)"
  }

  // so now, we just want to know the count of possible fresh ids
  func part2() -> Any {
    return "\(theRanges.count)"
  }

}
