import Foundation
import Parsing

final class Day09: AdventDay {
  let diskMap: [Int]

  init(data: String) {
    var modifiableInput = data[...]
    do {
      diskMap = try Parse(input: Substring.self) {
        Many(element: { Digits(1) })
      }.parse(&modifiableInput)
    } catch {
      print("Error parsing data: \(error.localizedDescription)")
      diskMap = []
    }
  }

  func buildDisk() -> [DiskSector] {
    let totalSize: Int = diskMap.reduce(0, +)
    var fileID = 0
    return Array<DiskSector>(unsafeUninitializedCapacity: totalSize,
                                               initializingWith: { buffer, count in
      var sectorKind: DiskSector = .file(fileID)
      for blockCount in diskMap {
        if blockCount > 0 {
          for _ in 0..<blockCount {
            buffer[count] = sectorKind
            count += 1
          }
        }
        switch sectorKind {
        case .empty:
          fileID += 1
          sectorKind = .file(fileID)
        case .file:
          sectorKind = .empty
        }
      }
    })
  }

  func compact(disk: inout [DiskSector]) {
    var moveIndex = disk.count - 1
    while disk[moveIndex] == .empty && moveIndex > 0 { moveIndex -= 1 }
    var spaceIndex = disk.firstIndex(of: .empty) ?? disk.count
    while spaceIndex < moveIndex {
      disk.swapAt(spaceIndex, moveIndex)
      // now we adjust our markers
      while disk[moveIndex] == .empty && moveIndex > 0 { moveIndex -= 1 }
      spaceIndex = disk.firstIndex(of: .empty) ?? disk.count
    }
  }

  func checksum(disk: [DiskSector]) -> Int {
    var checksum = 0
    for (index, sector) in disk.enumerated() {
      switch sector {
      case let .file(fileID):
        checksum += index * fileID
      case .empty:
        continue
      }
    }
    return checksum
  }

  func noFragCompact(disk: inout [DiskSector]) {
    
  }

  func part1() -> Any {
    var disk = buildDisk()
    compact(disk: &disk)
    return "\(checksum(disk: disk))"
  }

  func part2() -> Any {
    return ""
  }

}

enum DiskSector: Equatable {

  static func ==(lhs: DiskSector, rhs: DiskSector) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
      return true
    case (.file(let lhsID), .file(let rhsID)):
      return lhsID == rhsID
    default:
      return false
    }
  }
  
  case empty
  case file(Int)
}
