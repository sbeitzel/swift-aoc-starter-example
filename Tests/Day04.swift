import Testing

@testable import AdventOfCode

final class Day04Tests {

  let testData = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

  @Test func testDownLeftSlicing() async throws {
    let challenge = Day04(data: testData)
    let slices = challenge.downLeftSlices(for: challenge.inputLines)
    #expect(slices.count == 19)
    #expect(slices[2] == "MSA")
    #expect(slices[14] == "ASAMX")
  }

  @Test func testDownRightSlicing() async throws {
    let challenge = Day04(data: testData)
    let slices = challenge.downRightSlices(for: challenge.inputLines)
    #expect(slices.count == 19)
    #expect(slices[2] == "ASM")
    #expect(slices[14] == "XMXMA")
  }

  @Test func testGetGridStrings() async throws {
    let challenge = Day04(data: testData)
    let grid = challenge.gridStrings(for: challenge.inputLines)
    #expect(grid.count == 64)
  }

  @Test func testCount() async throws {
    let challenge = Day04(data: testData)
    #expect(challenge.count(in: challenge.inputLines) == 5)
  }

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part1()) == "18")
  }

  @Test func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(String(describing: challenge.part2()) == "9")
  }

}
