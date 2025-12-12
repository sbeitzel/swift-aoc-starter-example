import Foundation
import Parsing

final class Day06: AdventDay {
  let operands: [[Int]]
  let operators: [Operator]

  init(data: String) {
    let operandsParser = Many(element: { Parse(input: Substring.self) {
      Int.parser()
    }},
                              separator: { CharacterSet.whitespaces })
    let operatorsParser = Parse(input: Substring.self) {
      Many(element: { OneOf {
        "+".map { Operator.add }
        "*".map { Operator.multiply }
      }},
           separator: { CharacterSet.whitespaces })
    }
    let fullParser = Parse(input: Substring.self) {
      Many(element: { operandsParser },
           separator: { "\n" })
      operatorsParser
    }
    do {
      var modifiableInput = data[...]
      let (scannedValues, scannedOps) = try fullParser.parse(&modifiableInput)
      self.operands = scannedValues
      self.operators = scannedOps
    } catch {
      print("Parsing failed! \(error.localizedDescription)")
      operands = []
      operators = []
    }
  }

  func part1() -> Any {
    return ""
  }

  func part2() -> Any {
    return ""
  }

  enum Operator {
    case add
    case multiply
  }
}
