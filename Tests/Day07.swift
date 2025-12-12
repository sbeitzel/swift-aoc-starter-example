import Testing

@testable import AdventOfCode

final class Day07Tests {

  let testData = """

    """

  @Test func testPart1() async throws {
    let challenge = Day07(data: testData)
    #expect(String(describing: challenge.part1()) == "")
  }

  @Test func testPart2() async throws {
    let challenge = Day07(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }

}
