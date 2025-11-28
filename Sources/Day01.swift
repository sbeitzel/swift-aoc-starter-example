import Foundation
import Parsing

final class Day01: AdventDay {

  let parsedListA: [Int]
  let parsedListB: [Int]

  init(data: String) {
    let locationIDTupleParser = Parse(input: Substring.self) {
        Int.parser()
        "   "
        Int.parser()
    }
    // split the data string into lines
    let inputLines = data.split(separator: "\n").map { String($0) }
    var listA: [Int] = []
    var listB: [Int] = []
    for line in inputLines {
      var modifiableInput = line[...]
      do {
        let tuple = try locationIDTupleParser.parse(&modifiableInput)
        listA.append(tuple.0)
        listB.append(tuple.1)
      } catch {
        print("Error parsing input: \(error.localizedDescription)")
      }
    }

    self.parsedListA = listA
    self.parsedListB = listB
  }

  func part1() -> Any {
    var list: [Int] = []
    for pair in zip(parsedListA.sorted(), parsedListB.sorted()) {
        list.append(abs(pair.0 - pair.1))
    }

    return "\(list.reduce(0) { $0 + $1 })"
  }

  func part2() -> Any {
    var frequencies: [Int: Int] = [:]
    for number in parsedListB {
        frequencies[number, default: 0] += 1
    }

    return "\(parsedListA.reduce(0) { $0 + frequencies[$1, default: 0] * $1 })"
  }

}
