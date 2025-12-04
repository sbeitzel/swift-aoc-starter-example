import Foundation
import Parsing

final class Day01: AdventDay {
  let rotations: [Int]

  init(data: String) {
    var rotations: [Int] = []
    // we're getting a sequence of rotation instructions, to either increment or decrement the pointer value
    let positiveParser = Parse(input: Substring.self) {
      "R"
      Int.parser()
    }
    let negativeParser = Parse(input: Substring.self) {
      "L"
      Int.parser()
    }.map( { $0 * -1 })
    let rotationParser = OneOf {
      positiveParser
      negativeParser
    }
    let lines = data.split(separator: "\n").map { String($0) }
    for line in lines {
      var modifiableInput = line[...]
      do {
        let rotation = try rotationParser.parse(&modifiableInput)
        rotations.append(rotation)
      } catch {
        print("Failed to parse rotation: \(line)")
      }
    }
    self.rotations = rotations
  }

  func part1() -> Any {
    var pointer = 50
    var zeroes = 0
    for turn in rotations {
      pointer = (pointer + (turn % 100)) % 100
      if pointer < 0 {
        pointer += 100
      }
      if pointer == 0 {
        zeroes += 1
      }
    }
    return "\(zeroes)"
  }

  func part2() -> Any {
    var pointer = 50
    var zeroes = 0
    for turn in rotations {
      let oldPosition = pointer
      // how many full rotations in the turn?
      let (q, r) = abs(turn).quotientAndRemainder(dividingBy: 100)
      zeroes = zeroes + q
      var increment = r
      if turn < 0 {
        increment = -1 * increment
      }
      pointer = pointer + increment
      // now, if pointer is negative, we've once more gone past zero
      // also, the new value of pointer should be the negative value plus 100
      if pointer < 0 {
        pointer += 100
        // if we *started* at zero, then that already got counted last time
        if oldPosition > 0 {
          zeroes += 1
        }
      } else if pointer > 99 {
        pointer -= 100
        zeroes += 1
      } else if pointer == 0 {
        zeroes += 1
      }
    }
    return "\(zeroes)"
  }

}
