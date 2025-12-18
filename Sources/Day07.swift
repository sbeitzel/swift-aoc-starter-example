import Foundation
import Parsing

final class Day07: AdventDay {
  let problems: [(Int, [Int])]

  init(data: String) {
    let problem = Parse(input: Substring.self) {
      Int.parser()
      ": "
      Many(element: { Int.parser() },
           separator: { CharacterSet.whitespaces })
    }
    let fullInput = Many(element: { problem },
                         separator: { CharacterSet.newlines })
    var modifiableInput = data[...]
    do {
      problems = try fullInput.parse(&modifiableInput)
    } catch {
      print("Error parsing input data: \(error.localizedDescription)")
      problems = []
    }
  }

  func part1() -> Any {
    return ""
  }

  func part2() -> Any {
    return ""
  }

}
