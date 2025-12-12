import Testing

@testable import AdventOfCode

final class Day09Tests {

  let testData = """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

  @Test func testParsing() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.tiles.count == 8)
  }
  
  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part1()) == "50")
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }

}
