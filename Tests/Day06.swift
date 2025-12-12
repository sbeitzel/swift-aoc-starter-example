import Testing

@testable import AdventOfCode

final class Day06Tests {

  let testData = """
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
    """

  @Test func testParsing() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.operands.count == 3)
    #expect(challenge.operators.count == 4)
  }

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(String(describing: challenge.part1()) == "4277556")
  }

  @Test func testPart2() async throws {
    let challenge = Day06(data: testData)
    #expect(String(describing: challenge.part2()) == "")
  }

}
