import Testing

@testable import AdventOfCode

final class Day01Tests {

  let testData = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

  @Test func testParsing() async throws {
    let challenge = Day01(data: testData)
    #expect(challenge.rotations.count == 10)
    #expect(challenge.rotations.first! == -68)
  }

  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part1()) == "3")
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part2()) == "6")
  }

}
