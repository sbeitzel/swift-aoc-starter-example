import Testing

@testable import AdventOfCode

final class Day09Tests {

  let testData = """
    2333133121414131402
    """

  let testDisk: [DiskSector] = [.file(0), .file(0),
                                .empty, .empty, .empty,
                                .file(1),.file(1),.file(1),
                                .empty, .empty, .empty,
                                .file(2),
                                .empty, .empty, .empty,
                                .file(3), .file(3), .file(3),
                                .empty,
                                .file(4), .file(4),
                                .empty,
                                .file(5), .file(5), .file(5), .file(5),
                                .empty,
                                .file(6), .file(6), .file(6), .file(6),
                                .empty,
                                .file(7), .file(7), .file(7),
                                .empty,
                                .file(8), .file(8), .file(8), .file(8),
                                .file(9), .file(9)]

  @Test func testParse() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.diskMap.count == 19)
  }

  @Test func testBuildDisk() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.buildDisk() == testDisk)
  }

  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part1()) == "1928")
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(String(describing: challenge.part2()) == "2858")
  }

}
