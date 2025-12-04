import Testing

@testable import AdventOfCode

final class Day04Tests {

  let testData = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part1()) == "13")
  }

  @Test func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part2()) == "43")
  }
}
