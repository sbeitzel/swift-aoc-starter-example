import Foundation
import Parsing

final class Day03: AdventDay {

  let instructions: [Day03Solver.Instruction]

  init(data: String) {
    let mulParser = Parse(input: Substring.self) {
        "mul("
        Int.parser()
        ","
        Int.parser()
        ")"
    }.map { Day03Solver.Instruction.multiply($0, $1)}

    let doParser = Parse(input: Substring.self) {
        "do()"
    }.map { Day03Solver.Instruction.process }

    let doNotParser = Parse(input: Substring.self) {
        "don't()"
    }.map { Day03Solver.Instruction.noProcessing }

    let memoryParser = OneOf {
        mulParser
        doParser
        doNotParser
    }
    var modifiableInput = data[...]
    var instructions: [Day03Solver.Instruction] = []
    while !modifiableInput.isEmpty {
        do {
            let instruction = try memoryParser.parse(&modifiableInput)
            // it worked!
            instructions.append(instruction)
        } catch {
            // okay, so, pop off the first character and try again
            _ = modifiableInput.popFirst()
        }
    }
    self.instructions = instructions
  }

  func part1() -> Any {
    let solver = Day03Solver(stack: instructions.filter({ $0 != .noProcessing && $0 != .process }))
    solver.runStack()
    return "\(solver.result)"
  }

  func part2() -> Any {
    let solver = Day03Solver(stack: instructions)
    solver.runStack()
    return "\(solver.result)"
  }

}

class Day03Solver {
    enum Instruction: Equatable {
        case multiply(Int, Int)
        case noProcessing
        case process
    }

    var stack: [Instruction]
    var result: Int

    init(stack: [Instruction]) {
        self.result = 0
        self.stack = stack
    }

    func runStack() {
        var isProcessing = true
        while !stack.isEmpty {
            let instruction = stack.removeFirst()
            switch instruction {
            case .multiply(let multiplier, let multiplier2):
                if isProcessing {
                    result += multiplier * multiplier2
                }
            case .noProcessing:
                isProcessing = false
            case .process:
                isProcessing = true
            }
        }
    }
}
