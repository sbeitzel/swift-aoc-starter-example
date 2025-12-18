import Testing

@testable import AdventOfCode

final class Day07Tests {

  let testData = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

  @Test func testParsing() async throws {
    let challenge = Day07(data: testData)
    #expect(challenge.problems.count == 9)
    #expect(challenge.problems[2].0 == 83)
    #expect(challenge.problems[2].1[0] == 17)
    #expect(challenge.problems[7].1.count == 4)
  }

  @Test func testOperatorGeneration() async throws {
    let challenge = Day07(data: testData)
    var sequences = challenge.generateOperatorSequences(ofLength: 2, using: [.times, .plus])
    #expect(sequences.count == 4)
    sequences = challenge.generateOperatorSequences(ofLength: 3, using: [.plus, .times])
    #expect(sequences.count == 8)
  }

  @Test func testPart1() async throws {
    let challenge = Day07(data: testData)
    #expect(String(describing: challenge.part1()) == "3749")
  }

  @Test func testPart2() async throws {
    let challenge = Day07(data: testData)
    #expect(String(describing: challenge.part2()) == "11387")
  }

}
