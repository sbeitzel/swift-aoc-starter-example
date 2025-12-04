import Foundation

final class Day04: AdventDay {
  let grid: [[Bool]]

  init(data: String) {
    var workingGrid: [[Bool]] = []
    for line in data.split(separator: "\n") {
      var row: [Bool] = []
      for char in line {
        row.append(char == "@")
      }
      workingGrid.append(row)
    }
    grid = workingGrid
  }

  func isEmpty(_ x: Int, _ y: Int, map: [[Bool]]) -> Bool {
    guard x >= 0, y >= 0, y < map.count else { return true }
    guard x < map[y].count else { return true }
    return !map[y][x]
  }

  func countNeighbors(_ x: Int, _ y: Int, map: [[Bool]]) -> Int {
    var count: Int = 0
    for dy in -1...1 {
      for dx in -1...1 {
        if dx == 0 && dy == 0 { continue }
        if !isEmpty(x + dx, y + dy, map: map) { count += 1 }
      }
    }
    return count
  }

  func isAccessible(_ x: Int, _ y: Int, map: [[Bool]]) -> Bool {
    return countNeighbors(x, y, map: map) < 4
  }

  func part1() -> Any {
    var accessibleCount: Int = 0
    for row in 0..<grid.count {
      for column in 0..<grid[row].count where grid[row][column] {
        if isAccessible(column, row, map: grid) { accessibleCount += 1 }
      }
    }
    return "\(accessibleCount)"
  }

  func part2() -> Any {
    var keepChecking = true
    var basisMap = grid
    var totalRemoved = 0

    while keepChecking {
      let passResult = countAndClear(basisMap)
      totalRemoved += passResult.numberRemoved
      if passResult.numberRemoved == 0 {
        keepChecking = false
      } else {
        basisMap = passResult.grid
      }
    }

    return "\(totalRemoved)"
  }

  struct RemovalPassResult {
    var numberRemoved: Int = 0
    var grid: [[Bool]]
  }

  func countAndClear(_ warehouse: [[Bool]]) -> RemovalPassResult {
    var result: RemovalPassResult = .init(grid: warehouse)
    for row in 0..<warehouse.count {
      for column in 0..<warehouse[row].count where warehouse[row][column] {
        if isAccessible(column, row, map: warehouse) {
          result.numberRemoved += 1
          result.grid[row][column] = false
        }
      }
    }
    return result
  }
}
