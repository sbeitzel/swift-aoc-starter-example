import Foundation

final class Day03: AdventDay {
  let batteryBanks: [[Int]]

  init(data: String) {
    let lines = data.split(separator: "\n")
    var banks: [[Int]] = []
    for line in lines {
      var bank: [Int] = []
      // split it into digits
      for (_, digit) in line.enumerated() {
        bank.append(Int(String(digit))!)
      }
      banks.append(bank)
    }
    batteryBanks = banks
  }

  func part1() -> Any {
    let maxPower = batteryBanks
      .map { recursiveMaximizer($0, expectedDigits: 2) }
      .reduce(0, +) // sum the joltages
    return "\(maxPower)"
  }

  func recursiveMaximizer(_ bank: [Int], expectedDigits: Int) -> Int {
    guard expectedDigits > 0, expectedDigits <= bank.count else {
      print("Fatal recursion logic flaw!")
      return 0
    }
    if expectedDigits == 1 {
      // find the greatest value in the entire bank
      var myDigit = 0
      for i in (0)..<bank.count {
        if bank[i] > myDigit {
          myDigit = bank[i]
        }
      }
      return myDigit
    } else {
      // find the greatest value from bank[0] to bank[bank.count - expectedDigits]
      var myDigit = 0
      var myIndex = 0
      for i in 0..<(bank.count - (expectedDigits - 1)) {
        if bank[i] > myDigit {
          myDigit = bank[i]
          myIndex = i
        }
      }
      let subBank: [Int] = Array(bank.suffix(bank.count - (myIndex + 1)))
      let rightValue = recursiveMaximizer(subBank, expectedDigits: expectedDigits - 1)
      var placeValue = 1
      for _ in 1..<expectedDigits {
        placeValue = placeValue * 10
      }
      return (myDigit * placeValue) + rightValue
    }
  }

  func part2() -> Any {
    let maxPower = batteryBanks
      .map { recursiveMaximizer($0, expectedDigits: 12) }
      .reduce(0, +) // sum the joltages
    return "\(maxPower)"
  }

}
