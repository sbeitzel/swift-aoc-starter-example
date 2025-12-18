import Foundation
import Testing

@testable import AdventOfCode

final class Day11Tests {

  let testData = """
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
    """

  let secondTestData = """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

  @Test func testParsing() async throws {
    let challenge = Day11(data: testData)
    #expect(challenge.routing.count == 10)
  }

  @Test func testPart1() async throws {
    let challenge = Day11(data: testData)
    #expect(String(describing: challenge.part1()) == "5")
  }

  @Test func testPart2() async throws {
    let challenge = Day11(data: secondTestData)
    #expect(String(describing: challenge.part2()) == "2")
  }

  @Test func testCreateSerializedGraphe() async throws {
    let challenge = Day11(data: secondTestData)
    let serialized = try JSONEncoder().encode(challenge.buildGraph())
    print("Serialized graph: \n\n\(String(decoding: serialized, as: UTF8.self))")
  }
}
