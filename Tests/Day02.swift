import Testing

@testable import AdventOfCode

final class Day02Tests {

  let testData = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  @Test func testParsing() async throws {
    let challenge = Day02(data: testData)
    #expect(challenge.ranges.count == 11)
    #expect(challenge.ranges[0].0 == 11)
    #expect(challenge.ranges[0].1 == 22)
  }

  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "1227775554")
  }

  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "4174379265")
  }

}
