import Algorithms
import Foundation
import Parsing

final class Day09: AdventDay {
  let tiles: [Tile]

  init(data: String) {
    let tileParser = Parse(input: Substring.self) {
      Int.parser()
      ","
      Int.parser()
    }.map(Tile.init)
    let floorParser = Many(element: { tileParser },
    separator: { "\n" })
    var modifiableInput = data[...]
    tiles = try! floorParser.parse(&modifiableInput)
  }

  func part1() -> Any {
    let rectangles: [RedRect] = tiles.combinations(ofCount: 2).map { RedRect(cornerA: $0[0], cornerB: $0[1]) }
      .sorted(by: { $0.size > $1.size })

    guard let biggest = rectangles.first else { return "No rectangles!" }
    return "\(biggest.size)"
  }

  func part2() -> Any {
    return ""
  }

}

struct Tile {
  let row: Int
  let col: Int
}

struct RedRect {
  let cornerA: Tile
  let cornerB: Tile

  var size: Int {
    // (dx + 1) * (dy + 1)
    let dx = abs(cornerA.col - cornerB.col)
    let dy = abs(cornerA.row - cornerB.row)
    return (dx + 1) * (dy + 1)
  }
}
