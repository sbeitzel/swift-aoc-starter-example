import Foundation
import Parsing

final class Day05: AdventDay {
  let orderRules: [(Int, Int)]
  let printerRules: [[Int]]
  let precedences: [Int: Set<Int>]

  init(data: String) {
    let orderParser = Parse(input: Substring.self) {
      Int.parser()
      "|"
      Int.parser()
    }
    let intParser = Parse(input: Substring.self) { Int.parser() }
    let printParser = Many {
      intParser
    } separator: {
      ","
    }

    var orderDictionary: [Int: Set<Int>] = [:]

    // our inputs are orderRules (A must come before B), printer rules (print pages A, B, C, D), or separators
    let lines = data.split(separator: "\n")
    var orderTuples: [(Int, Int)] = []
    var printRequests: [[Int]] = []
    for line in lines {
      var modifiableLine = line[...]
      if line.contains("|") {
        // it's an order rule
        do {
          let orderTuple = try orderParser.parse(&modifiableLine)
          orderTuples.append(orderTuple)
          if orderDictionary[orderTuple.0] == nil {
            orderDictionary[orderTuple.0] = [orderTuple.1]
          } else {
            orderDictionary[orderTuple.0]?.insert(orderTuple.1)
          }
        } catch {
          // whoops
          print("Error parsing order line: \(line)\n\t\(error.localizedDescription)")
        }
      } else if line.contains(",") {
        // it's a print request
        do {
          let printRequest = try printParser.parse(&modifiableLine)
          printRequests.append(Array(printRequest))
        } catch {
          print("Error parsing print line: \(line)\n\t\(error.localizedDescription)")
        }
      }
    }
    orderRules = orderTuples
    printerRules = printRequests
    precedences = orderDictionary
  }

  func part1() -> Any {
    // first, collect all the valid jobs
    var validJobs: [[Int]] = []
    for request in printerRules {
      if printJobPasses(request) {
        validJobs.append(request)
      }
    }
    // sum the middle page number for each job
    let middleSum = (validJobs.map { list in
      let middle = ((list.count + 1) / 2) - 1
      return list[middle]
    }).reduce(0, +)
    return "\(middleSum)"
  }

  func part2() -> Any {
    // collect all the invalid jobs
    var invalidJobs: [[Int]] = []
    for request in printerRules {
      if !printJobPasses(request) {
        invalidJobs.append(request)
      }
    }
    // sort each job
    let sortedJobs: [[Int]] = invalidJobs.map {
      $0.sorted(by: {left, right in
        precedences[left]?.contains(right) ?? false
      })
    }
    // sum the middle page number for each job
    let middleSum = (sortedJobs.map { list in
      let middle = ((list.count + 1) / 2) - 1
      return list[middle]
    }).reduce(0, +)
    return "\(middleSum)"
  }

  func printJobPasses(_ request: [Int]) -> Bool {
    // for every page, request[p], it must be true that request[p-i] is not in the precedence list for request[p]
    var okay = true
    var pageIndex = request.count - 1
    while pageIndex > 0 && okay {
      var i = 0
      while i < pageIndex && okay {
        let prior = request[i]
        let current = request[pageIndex]
        // do we have a rule that says current must come before prior? If so, we are not okay.
        okay = !(precedences[current]?.contains(prior) ?? false)
        i += 1
      }
      pageIndex -= 1
    }
    return okay
  }
}
