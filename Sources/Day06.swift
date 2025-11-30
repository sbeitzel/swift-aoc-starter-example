import Foundation

final class Day06: AdventDay {
  let map: [[MapTile]]
  let guardPosition: (Int, Int)
  let guardOrientation: Orientation

  init(data: String) {
    let lines = data.split(separator: "\n")
    var yPos = 0
    var map: [[MapTile]] = []
    var guardPosition: (Int, Int) = (-1, -1)
    var orientation: Orientation = .up
    while yPos < lines.count {
      var mapRow: [MapTile] = []
      for (xPos, tileChar) in lines[yPos].enumerated() {
          switch tileChar {
          case "#":
            mapRow.append(.blocked)
          case ".":
            mapRow.append(.clear)
          case "^":
            mapRow.append(.clear)
            guardPosition = (xPos, yPos)
            orientation = .up
          case ">":
            mapRow.append(.clear)
            guardPosition = (xPos, yPos)
            orientation = .right
          case "v":
            mapRow.append(.clear)
            guardPosition = (xPos, yPos)
            orientation = .down
          case "<":
            mapRow.append(.clear)
            guardPosition = (xPos, yPos)
            orientation = .left
          default:
            print("Error parsing row \(yPos) at \(xPos), unknown map character: \(tileChar)")
          }
      }
      map.append(mapRow)
      yPos += 1
    }
    self.map = map
    self.guardPosition = guardPosition
    self.guardOrientation = orientation
  }

  func part1() -> Any {
    let theGuard = Guard(position: guardPosition, orientation: guardOrientation)
    var onMap = theGuard.step(map)
    while onMap {
      onMap = theGuard.step(map)
    }
    return "\(theGuard.distinctPositions.count)"
  }

  func part2() -> Any {
    return ""
  }

}


enum MapTile {
  case clear, blocked
}

enum Orientation {
  case up, right, down, left

  func turn() -> Orientation {
    switch self {
    case .up:
        .right
    case .right:
        .down
    case .down:
        .left
    case .left:
        .up
    }
  }
}

struct Position: Hashable, Equatable, Identifiable {
  var id: String { "\(xPos),\(yPos)" }
  let xPos: Int
  let yPos: Int
}

class Guard {
  var position: Position
  var orientation: Orientation
  var totalSpaces: Int = 1
  var distinctPositions: Set<Position> = []

  init(position: (Int, Int), orientation: Orientation) {
    self.position = .init(xPos: position.0, yPos: position.1)
    self.orientation = orientation
    self.distinctPositions.insert(self.position)
  }

  func step(_ space: [[MapTile]]) -> Bool {
    let nextPos = self.nextPosition()
    // first, let's see if nextPos.0 is in the range 0..<space[0].count
    // and nextPos.1 is in the range 0..<space.count
    guard nextPos.0 >= 0, nextPos.0 < space[0].count, nextPos.1 >= 0, nextPos.1 < space.count else {
      // we're stepping off the map. No more positions, and we're done walking.
      print("Stepping off the map after \(totalSpaces) steps.")
      return false
    }
    // next, we see if nextPos is clear
    if space[nextPos.1][nextPos.0] == .blocked {
      // it is not. So, we turn 90 degrees to the right
      orientation = orientation.turn()
      return true
    } else {
      // clear. move into position.
      position = .init(xPos: nextPos.0, yPos: nextPos.1)
      distinctPositions.insert(position)
      totalSpaces += 1
      return true
    }
  }

  func nextPosition() -> (Int, Int) {
    switch orientation {
    case .up:
      (position.xPos, position.yPos - 1)
    case .right:
      (position.xPos + 1, position.yPos)
    case .down:
      (position.xPos, position.yPos + 1)
    case .left:
      (position.xPos - 1, position.yPos)
    }
  }
}
