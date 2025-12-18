import Foundation
import Parsing
import SwiftGraph

final class Day11: AdventDay {
  let routing: [String: [String]]

  init(data: String) {
    var modifiableInput = data[...]
    let device = Parse(input: Substring.self) {
      CharacterSet.alphanumerics
    }.map(String.init)
    let deviceRoute = Parse(input: Substring.self) {
      device
      ": "
      Many(element: { device }, separator: { " " })
    }
    let allRoutes = Many(element: { deviceRoute }, separator: { "\n" })
    let result = try! allRoutes.parse(&modifiableInput)
    var graph: [String: [String]] = [:]
    for route in result {
      graph[route.0] = route.1
    }
    routing = graph
  }

  func buildGraph() -> UnweightedGraph<String> {
    let rack = UnweightedGraph<String>(vertices: routing.keys.map(\.self))
    _ = rack.addVertex("out")
    routing.forEach { device, destinations in
      for destination in destinations {
        rack.addEdge(from: device, to: destination, directed: true)
      }
    }
    return rack
  }

  func part1() -> Any {
    let serverRack = buildGraph()
    var excludeNodes: Set<String> = []
    let paths = serverRack.countPaths(from: "you", to: "out", visited: &excludeNodes)
    return "\(paths)"
  }

  func part2() -> Any {
    let serverRack = buildGraph()

    // Let's aggressively prune the search space by precomputing the reachability of
    // the destinations. This means we don't have to waste a bunch of time following
    // the same dead ends over and over.
    guard let svrIndex = serverRack.indexOfVertex("svr") else { return "No svr" }
    guard let dacIndex = serverRack.indexOfVertex("dac") else { return "No dac" }
    guard let fftIndex = serverRack.indexOfVertex("fft") else { return "No fft" }
    guard let outIndex = serverRack.indexOfVertex("out") else { return "No out" }
    let dacReachability = serverRack.reachabilityOf(dacIndex)
    let fftReachability = serverRack.reachabilityOf(fftIndex)
    let outReachability = serverRack.reachabilityOf(outIndex)

    // there are two possible combinations of three legs we will accept:
    // svr -> fft -> dac -> out
    // svr -> dac -> fft -> out
    // so we compute all the allowable legs and we combine them
    var excludeNodes: Set<Int> = [svrIndex, outIndex]
    let dac2fft = serverRack.countPaths(fromIndex: dacIndex, toIndex: fftIndex, visited: &excludeNodes, reachability: fftReachability)
    print("Found \(dac2fft) paths from dac -> fft")
    excludeNodes = [svrIndex, outIndex]
    let fft2dac = serverRack.countPaths(fromIndex: fftIndex, toIndex: dacIndex, visited: &excludeNodes, reachability: dacReachability)
    print("Found \(fft2dac) paths from fft -> dac")

    // we've now computed the count of all the possible middle legs. So that means we have
    // an opportunity to avoid the ends if a given middle has no paths
    var dac2out = 0
    var svr2fft = 0
    if fft2dac > 0 {
      // we need to compute svr -> fft and dac2out
      excludeNodes = [svrIndex, fftIndex]
      dac2out = serverRack.countPaths(fromIndex: dacIndex, toIndex: outIndex, visited: &excludeNodes, reachability: outReachability)
      print("Found \(dac2out) paths from dac -> out")
      excludeNodes = [dacIndex, outIndex]
      svr2fft = serverRack.countPaths(fromIndex: svrIndex, toIndex: fftIndex, visited: &excludeNodes, reachability: fftReachability)
      print("Found \(svr2fft) paths from svr -> fft")
    }

    var svr2dac = 0
    var fft2out = 0
    if dac2fft > 0 {
      // svr -> dac
      excludeNodes = [fftIndex, outIndex]
      svr2dac = serverRack.countPaths(fromIndex: svrIndex, toIndex: dacIndex, visited: &excludeNodes, reachability: dacReachability)
      print("Found \(svr2dac) paths from svr -> dac")
      // fft -> out
      excludeNodes = [svrIndex, dacIndex]
      fft2out = serverRack.countPaths(fromIndex: fftIndex, toIndex: outIndex, visited: &excludeNodes, reachability: outReachability)
      print("Found \(fft2out) paths from fft -> out")
    }
    let sfdo = svr2fft * fft2dac * dac2out
    print("svr -> fft -> dac -> out: \(sfdo)")
    let sdfo = svr2dac * dac2fft * fft2out
    print("svr -> dac -> fft -> out: \(sdfo)")

    return "\(sfdo + sdfo)"
  }
}

extension Graph {
  /// Find all of the neighbors of a vertex at a given index.
  ///
  /// - parameter index: The index for the vertex to find the neighbors of.
  /// - returns: An array of the neighbor vertex indices.
  public func neighborIndicesForIndex(_ index: Int) -> [Int] {
    return edges[index].map({$0.v})
  }

  /// Find a route from one vertex to another using a depth-first search.
  ///
  /// - parameter fromIndex: The index of the starting vertex.
  /// - parameter toIndex: The index of the ending vertex.
  /// - returns: `true` if a path exists
  func pathExists(fromIndex: Int, toIndex: Int) -> Bool {
      // pretty standard dfs that doesn't visit anywhere twice
      var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
      var stack: [Int] = []
      stack.append(fromIndex)
      while !stack.isEmpty {
        if let v: Int = stack.popLast() {
          if (visited[v]) {
            continue
          }
          visited[v] = true
          if v == toIndex {
            // we've found the destination
            return true
          }
          for e in edgesForIndex(v) {
            if !visited[e.v] {
              stack.append(e.v)
            }
          }
        }
      }
      return false // no solution found
  }

  /// This is an exhaustive search to find out how many paths there are between two vertices.
  ///
  /// - parameter fromIndex: the index of the starting vertex
  /// - parameter toIndex: the index of the destination vertex
  /// - parameter visited: a set of vertex indices which will be considered to have been visited already
  /// - returns: the number of paths that exist going from the start to the destinatin
  func countPaths(fromIndex startIndex: Int, toIndex endIndex: Int, visited: inout Set<Int>) -> Int {
    if startIndex == endIndex { return 1 }
    visited.insert(startIndex)
    var total = 0
    for n in neighborIndicesForIndex(startIndex) where !visited.contains(n) {
      total += countPaths(fromIndex: n, toIndex: endIndex, visited: &visited)
    }
    visited.remove(startIndex)
    return total
  }

  /// This is an exhaustive search to find out how many paths there are between two vertices.
  /// The search is optimized by not bothering to compute paths for known dead ends.
  ///
  /// - parameter fromIndex: the index of the starting vertex
  /// - parameter toIndex: the index of the destination vertex
  /// - parameter visited: a set of vertex indices which will be considered to have been visited already
  /// - parameter reachability: a dictionary where the key is a vertex index and the value is whether or not a path exists from that vertex to the destination
  /// - returns: the number of paths that exist going from the start to the destinatin
  func countPaths(fromIndex startIndex: Int, toIndex endIndex: Int, visited: inout Set<Int>, reachability: [Int: Bool]) -> Int {
    if startIndex == endIndex { return 1 }
    guard reachability[startIndex] ?? false else { return 0 }
    visited.insert(startIndex)
    var total = 0
    for n in neighborIndicesForIndex(startIndex) where !visited.contains(n) && (reachability[n] ?? false) {
      total += countPaths(fromIndex: n, toIndex: endIndex, visited: &visited, reachability: reachability)
    }
    visited.remove(startIndex)
    return total
  }

  /// Computes whether or not a given vertex (by index) is reachable from every other vertex in the graph.
  func reachabilityOf(_ index: Int) -> [Int: Bool] {
    var answers: [Int: Bool] = [:]
    for vi in vertices.indices {
      answers[vi] = pathExists(fromIndex: vi, toIndex: index)
    }
    return answers
  }

}

extension Graph where V: Hashable {
  /// A depth-first search to find *all* the paths between two vertices in a graph.
  func findPaths(from start: V, to end: V, visited: Set<V>) -> [[V]] {
    if start == end {
      return [[end]]
    }
    let myVisited = visited.union([start])
    var myPaths: [[V]] = []
    for neighbor in neighborsForVertex(start) ?? [] where !myVisited.contains(neighbor) {
      let foundPaths = findPaths(from: neighbor, to: end, visited: myVisited)
      for path in foundPaths {
        myPaths.append([start] + path)
      }
    }
    return myPaths
  }

  func countPaths(from start: V, to end: V, visited: inout Set<V>) -> Int {
    if start == end { return 1 }
    // convert all these vertices into indices and use the faster version
    guard let startIndex = indexOfVertex(start) else { return 0 }
    guard let endIndex = indexOfVertex(end) else { return 0 }
    let endReachability = reachabilityOf(endIndex)
    var visitedIndices: Set<Int> = []
    for node in visited {
      if let nodeIndex = indexOfVertex(node) {
        visitedIndices.insert(nodeIndex)
      }
    }
    return countPaths(fromIndex: startIndex, toIndex: endIndex, visited: &visitedIndices, reachability: endReachability)
  }

}
