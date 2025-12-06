import Testing

@testable import AdventOfCode

final class Day05Tests {

  let testData = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

  @Test func testParsing() async throws {
    let challenge = Day05(data: testData)
    #expect(challenge.ingredients.count == 6)
    #expect(challenge.theRanges.count == 14)
  }

  @Test func testPart1() async throws {
    let challenge = Day05(data: testData)
    #expect(String(describing: challenge.part1()) == "3")
  }

  @Test func testPart2() async throws {
    let challenge = Day05(data: testData)
    #expect(String(describing: challenge.part2()) == "14")
  }

}
