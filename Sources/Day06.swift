import Foundation

final class Day06: AdventDay {

  init(data: String) {
  }

  func part1() -> Any {
    return ""
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

class Guard {
  var position: (Int, Int)
  var orientation: Orientation
  var totalSpaces: Int = 1

  init(position: (Int, Int), orientation: Orientation) {
    self.position = position
    self.orientation = orientation
  }

  func step(_ space: [[MapTile]]) -> Bool {
    var stillInMap = true
    let nextPos = self.nextPosition()
    // first, let's see if nextPos.0 is in the range 0..<space[0].count
    // and nextPos.1 is in the range 0..<space.count
    guard nextPos.0 >= 0, nextPos.0 < space[0].count, nextPos.1 >= 0, nextPos.1 < space.count else {
      // we're stepping off the map. No more positions, and we're done walking.
      return false
    }
    // next, we see if nextPos is clear
    if space[nextPos.1][nextPos.0] == .blocked {
      // it is not. So, we turn 90 degrees to the right
      orientation = orientation.turn()
      return true
    } else {
      // clear. move into position.
      position = nextPos
      totalSpaces += 1
      return true
    }
  }

  func nextPosition() -> (Int, Int) {
    switch orientation {
    case .up:
      (position.0, position.1 - 1)
    case .right:
      (position.0 + 1, position.1)
    case .down:
      (position.0, position.1 + 1)
    case .left:
      (position.0 - 1, position.1)
    }
  }
}
