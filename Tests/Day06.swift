import Testing

@testable import AdventOfCode

final class Day06Tests {

  let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

  @Test func testMapParsing() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.guardPosition == (4, 6))
    #expect(challenge.guardOrientation == .up)
    #expect(challenge.map.count == 10)
    for line in challenge.map {
      #expect(line.count == 10)
    }
  }

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(String(describing: challenge.part1()) == "41")
  }

  @Test func testPart2() async throws {
    let challenge = Day06(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }

}
