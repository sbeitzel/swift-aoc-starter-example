import Foundation
import Parsing

/// Not actually 2025 day 1, this is me noodling with 2024 day 4
final class Day01: AdventDay {

  let inputLines: [String]

  init(data: String) {
    // split the data string into lines
    inputLines = data.split(separator: "\n").map { String($0) }
  }

  func verticalLines(for grid: [String]) -> [String] {
    // we assume each line is the same length
    let lineLength = grid[0].count
    // now, we allocate that many strings
    var lines: [String] = Array(repeating: "", count: lineLength)
    for row in grid {
      for (index, char) in row.enumerated() {
        lines[index].append(char)
      }
    }
    return lines
  }

  func downRightSlices(for grid: [String]) -> [String] {
      var output: [String] = []
      var hopper: [String] = []
      var rework: [String] = []

      // while inputStock is not empty
      // - take a line from the inputStock and put it into the hopper
      // - set workingLine to the empty string
      // - for each line in the hopper,
      //  - remove the last character from the line and append it to workingLine
      //  - if the line is now empty, discard it. If it is not empty, put it in the rework pile
      // - add the (now completed) workingLine to the output pile
      // - put the rework pile back in the hopper
      for line in grid {
        hopper.append(line)
        var workingLine = ""
        for hLine in hopper {
          if let char = hLine.last {
            workingLine.append(String(char))
          }
          if hLine.count > 1 {
            rework.append(String(hLine.prefix(hLine.count - 1)))
          }
        }
        output.append(workingLine)
        hopper.removeAll()
        hopper.append(contentsOf: rework)
        rework.removeAll()
      }
      // at this point we have added all the input lines to the hopper, so we just have to grind until the hopper is empty
      while !hopper.isEmpty {
        var workingLine = ""
        for hLine in hopper {
          if let char = hLine.last {
            workingLine.append(String(char))
          }
          if hLine.count > 1 {
            rework.append(String(hLine.prefix(hLine.count - 1)))
          }
        }
        output.append(workingLine)
        hopper.removeAll()
        hopper.append(contentsOf: rework)
        rework.removeAll()
      }
      return output
  }

  func downLeftSlices(for grid: [String]) -> [String] {
    var output: [String] = []
    var hopper: [String] = []
    var rework: [String] = []

    // while inputStock is not empty
    // - take a line from the inputStock and put it into the hopper
    // - set workingLine to the empty string
    // - for each line in the hopper,
    //  - remove the first character from the line and append it to workingLine
    //  - if the line is now empty, discard it. If it is not empty, put it in the rework pile
    // - add the (now completed) workingLine to the output pile
    // - put the rework pile back in the hopper
    for line in grid {
      hopper.append(line)
      var workingLine = ""
      for hLine in hopper {
        if let char = hLine.first {
          workingLine.append(String(char))
        }
        if hLine.count > 1 {
          rework.append(String(hLine.suffix(hLine.count - 1)))
        }
      }
      output.append(workingLine)
      hopper.removeAll()
      hopper.append(contentsOf: rework)
      rework.removeAll()
    }
    // at this point we have added all the input lines to the hopper, so we just have to grind until the hopper is empty
    while !hopper.isEmpty {
      var workingLine = ""
      for hLine in hopper {
        if let char = hLine.first {
          workingLine.append(String(char))
        }
        if hLine.count > 1 {
          rework.append(String(hLine.suffix(hLine.count - 1)))
        }
      }
      output.append(workingLine)
      hopper.removeAll()
      hopper.append(contentsOf: rework)
      rework.removeAll()
    }
    return output
  }

  func count(in lines: [String]) -> Int {
    let forward = Parse(input: Substring.self) {
      "XMAS"
    }.map { true }
    let backward = Parse(input: Substring.self) {
      "SAMX"
    }.map { true }
    var counter = 0
    for line in lines {
      // forward
      var modifiableLine = line[...]
      while !modifiableLine.isEmpty {
        do {
          _ = try forward.parse(&modifiableLine)
          // it worked!
          counter += 1
        } catch {
          // oh well, pop off the first character and try again
          _ = modifiableLine.popFirst()
        }
      }
      // and backward
      modifiableLine = line[...]
      while !modifiableLine.isEmpty {
        do {
          _ = try backward.parse(&modifiableLine)
          // it worked!
          counter += 1
        } catch {
          // oh well, pop off the first character and try again
          _ = modifiableLine.popFirst()
        }
      }
    }
    return counter
  }

  func part1() -> Any {
    var counter = count(in: inputLines)
    counter += count(in: verticalLines(for: inputLines))
    counter += count(in: downLeftSlices(for: inputLines))
    counter += count(in: downRightSlices(for: inputLines))
    return "\(counter)"
  }

  func xmasMatches(_ line: String) -> Bool {
    let msms = Parse(input: Substring.self) {
      "M"
      Prefix(1)
      "S"
      Prefix(1)
      "A"
      Prefix(1)
      "M"
      Prefix(1)
      "S"
    }
    let mmss = Parse(input: Substring.self) {
      "M"
      Prefix(1)
      "M"
      Prefix(1)
      "A"
      Prefix(1)
      "S"
      Prefix(1)
      "S"
    }
    let smsm = Parse(input: Substring.self) {
      "S"
      Prefix(1)
      "M"
      Prefix(1)
      "A"
      Prefix(1)
      "S"
      Prefix(1)
      "M"
    }
    let ssmm = Parse(input: Substring.self) {
      "S"
      Prefix(1)
      "S"
      Prefix(1)
      "A"
      Prefix(1)
      "M"
      Prefix(1)
      "M"
    }
    let xmas = OneOf {
      msms
      mmss
      smsm
      ssmm
    }
    var search = line[...]
    do {
      _ = try xmas.parse(&search)
      return true
    } catch {
      return false
    }
  }

  func gridStrings(for input: [String]) -> [String] {
    // we want to get each distinct 3x3 grid from the input
    guard input.count >= 3 else {
      return []
    }
    guard input[0].count >= 3 else {
      return []
    }
    var grids: [String] = []
    for topIndex in 0..<input.count - 2 {
      for leftIndex in 0..<input[topIndex].count - 2 {
        // the three characters in input[topIndex] starting at the leftIndex position
        // the three characters in input[topIndex+1] starting at the leftIndex position
        // the three characters in input[topIndex+2] starting at the leftIndex position
        // concatenate the three substrings into a single string, and add it to grids
        let row1 = input[topIndex]
        let row2 = input[topIndex + 1]
        let row3 = input[topIndex + 2]

        let r1s = row1[row1.index(row1.startIndex, offsetBy: leftIndex)..<row1.index(row1.startIndex, offsetBy: leftIndex + 3)]
        let r2s = row2[row2.index(row2.startIndex, offsetBy: leftIndex)..<row2.index(row2.startIndex, offsetBy: leftIndex + 3)]
        let r3s = row3[row3.index(row3.startIndex, offsetBy: leftIndex)..<row3.index(row3.startIndex, offsetBy: leftIndex + 3)]

        let gridString = "\(r1s)\(r2s)\(r3s)"

        grids.append(gridString)
      }
    }
    return grids
  }

  func part2() -> Any {
    let grid = gridStrings(for: inputLines)
    var found = 0
    for line in grid {
      if xmasMatches(line) {
        found += 1
      }
    }
    return "\(found)"
  }

}
