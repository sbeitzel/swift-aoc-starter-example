import Algorithms
import Foundation
import Parsing
import SwiftGraph

final class Day08: AdventDay {
  let boxes: [JunctionBox]

  init(data: String) {
    let junctionParser = Parse(input: Substring.self) {
      Int.parser()
      ","
      Int.parser()
      ","
      Int.parser()
    }.map(JunctionBox.init)
    let boxesParser = Many(element: { junctionParser },
                           separator: { "\n" })
    var modifiableInput = data[...]
    boxes = try! boxesParser.parse(&modifiableInput)
  }

  func part1() -> Any {
    return parameterizedPart1(1000)
  }

  func parameterizedPart1(_ limit: Int) -> Any {
    let theRoom = hookEmUp(limit: limit)
    var circuits: [Set<JunctionBox>] = []

    for box in boxes {
      // is there a circuit that already includes this box?
      if !circuits.contains(where: { $0.contains(box) }) {
        let paths = theRoom.findAllBfs(from: box, goalTest: { _ in true })
        var circuit = Set<JunctionBox>()
        for path in paths {
          if let destination = path.last {
            let otherBox = theRoom.vertexAtIndex(destination.v)
            circuit.insert(otherBox)
          } else {
            // a zero length path is the starting vertex
            circuit.insert(box)
          }
        }
        circuits.append(circuit)
      }
    }

    // okay, sort the circuits by size
    circuits.sort(by: { $0.count > $1.count })

    // how big are the first three circuits?
    for (i, circuit) in circuits.prefix(3).enumerated() {
      print("Circuit \(i) has \(circuit.count) boxes")
    }

    let part1Product = circuits.prefix(3).reduce(1, { $0 * $1.count })

    return "\(part1Product)"
  }

  func hookEmUp(limit: Int) -> UnweightedGraph<JunctionBox> {
    let theRoom = UnweightedGraph<JunctionBox>(vertices: boxes)

    // now, let's get the box tuples sorted by distance
    let cables: [Cable] = boxes.combinations(ofCount: 2).map { Cable(endA: $0[0], endB: $0[1]) }
      .sorted(by: { $0.length < $1.length })

    for cable in cables.prefix(limit) {
      theRoom.addEdge(from: cable.endA, to: cable.endB, directed: false)
    }

    return theRoom
  }

  func part2() -> Any {
    // for this second part, we connect the boxes until we have connected all the boxes together.
    // Then, we perform a calculation on the coordinates of the last pair of boxes we connected.
    // The naive brute force method is just to attempt to connect every pair, only doing the connection
    // if the pair are not already in the same circuit, meanwhile keeping track of the last pair to
    // be connected. The obvious optimization to make here is to do some extra record keeping, but let's
    // only tackle that if the brute force, exhaustive method takes too long.

    // Update: it takes too long. This works, but it takes a few minutes.
    let theRoom = UnweightedGraph<JunctionBox>(vertices: boxes)

    let cables: [Cable] = boxes.combinations(ofCount: 2).map { Cable(endA: $0[0], endB: $0[1]) }
      .sorted(by: { $0.length < $1.length })

    var lastCable: Cable?
    for cable in cables {
      // if the ends are not connected, connect them
      let path = theRoom.bfs(from: cable.endA, to: cable.endB)
      if path.isEmpty {
        theRoom.addEdge(from: cable.endA, to: cable.endB, directed: false)
        lastCable = cable
      }
    }
    guard let lastCable else { return "Not enough cables!!!" }
    return "\(lastCable.endA.xLoc * lastCable.endB.xLoc)"
  }

}

struct Cable: Hashable, Identifiable, Equatable, Codable {
  var id: String { "\(endA.id)::\(endB.id)" }
  let endA: JunctionBox
  let endB: JunctionBox
  var length: Int {
    endA.closenessTo(endB)
  }
}

struct JunctionBox: Hashable, Identifiable, Equatable, Codable {
  var id: String { "\(xLoc)-\(yLoc)-\(zLoc)" }
  let xLoc: Int
  let yLoc: Int
  let zLoc: Int

  init(_ xCoord: Int, _ yCoord: Int, _ zCoord: Int) {
    xLoc = xCoord
    yLoc = yCoord
    zLoc = zCoord
  }

  /// This is the square of the Euclidean distance between the boxes
  func closenessTo(_ other: JunctionBox) -> Int {
    let dx = xLoc - other.xLoc
    let dy = yLoc - other.yLoc
    let dz = zLoc - other.zLoc
    return (dx * dx) + (dy * dy) + (dz * dz)
  }
}
