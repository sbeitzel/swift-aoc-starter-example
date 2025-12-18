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

  func isProblemSolvable(_ problem: (Int, [Int]), using operators: [Operator]) -> Bool {
    let opSequences = generateOperatorSequences(ofLength: problem.1.count - 1, using: operators)
    for sequence in opSequences {
      do {
        let result = try compute(operands: problem.1, operators: sequence)
        if result == problem.0 { return true }
      } catch {
        print("\(error.localizedDescription)")
      }
    }
    return false
  }

  func compute(operands: [Int], operators: [Operator]) throws -> Int {
    guard operands.count == operators.count + 1 else {
      throw AOCError.argumentCountMismatch("Expected \(operators.count + 1) operands")
    }
    guard operands.count > 0 else { return 0 }
    // process the operations in order
    var numberIndex = 1
    var register = operands[0]
    while numberIndex < operands.count {
      let op = operators[numberIndex - 1]
      register = op.combine(register, operands[numberIndex])
      numberIndex += 1
    }
    return register
  }

  func generateOperatorSequences(ofLength: Int, using operators: [Operator]) -> [[Operator]] {
    var sequences: [[Operator]] = []
    guard ofLength > 0 else { return sequences }
    if ofLength == 1 {
      return operators.map { [$0] }
    } else {
      let shorterSequences = generateOperatorSequences(ofLength: ofLength - 1, using: operators)
      // now we stick .plus and .times onto the front of each of these sequences
      for op in operators {
        let prefixedSequences = shorterSequences.map { [op] + $0 }
        sequences.append(contentsOf: prefixedSequences)
      }
      return sequences
    }
  }

  func part1() -> Any {
    var solvableSum: Int = 0
    for problem in problems {
      if isProblemSolvable(problem, using: [.plus, .times]) {
        solvableSum += problem.0
      }
    }
    return "\(solvableSum)"
  }

  func part2() -> Any {
    var solvableSum: Int = 0
    for problem in problems {
      if isProblemSolvable(problem, using: Operator.allCases) {
        solvableSum += problem.0
      }
    }
    return "\(solvableSum)"
  }

}

enum Operator: CaseIterable {
  case plus
  case times
  case concatenate

  func combine(_ a: Int, _ b: Int) -> Int {
    switch self {
    case .plus: return a + b
    case .times: return a * b
    case .concatenate: return Int("\(a)\(b)", radix: 10)!
    }
  }
}

enum AOCError: Error {
  case argumentCountMismatch(String)
}
