import Foundation
import Parsing

final class Day02: AdventDay {

  let reports: [[Int]]

  init(data: String) {
    let lines = data.split(separator: "\n").map { String($0) }
    let intParser = Parse(input: Substring.self) { Int.parser() }
    let rnrReportParser = Many {
        intParser
    } separator: {
        " "
    }
    reports = lines.map { line in
      var modifiableLine = line[...]
      do {
        return try rnrReportParser.parse(&modifiableLine)
      } catch {
        // parsing error. yikes.
        print("Parsing error: \(error.localizedDescription)")
        return []
      }
    }
  }

  func part1() -> Any {
    var safeCount: Int = 0
    print("Going through \(reports.count) reports")
    for report in reports {
      if isReportSafe(report) {
        safeCount += 1
      }
    }
    return "\(safeCount)"
  }

  func part2() -> Any {
    var safeCount: Int = 0
    for report in reports {
      if isDampenedReportSafe(report) {
        safeCount += 1
      }
    }
    return "\(safeCount)"
  }

  func isReportSafe(_ report: [Int]) -> Bool {
      // 'safe' means that each interval must have the same sign
      // AND that each interval must have magnitude (1..3)
      let intervals = report.adjacentPairs()
      var isSafe = true
      let isIncreasing: Bool = intervals.allSatisfy { $0.0 < $0.1 }
      if !isIncreasing {
          isSafe = intervals.allSatisfy { $0.0 > $0.1 }
      }
      if isSafe {
          for interval in intervals {
              let magnitude = abs(interval.0 - interval.1)
              if !(magnitude >= 1 && magnitude <= 3) {
                  return false
              }
          }
      }
      return isSafe
  }

  func isDampenedReportSafe(_ report: [Int]) -> Bool {
      for (ix, _) in report.enumerated() {
          var dampenedReport: [Int] = []
          if ix == 0 {
              // just exclude the first element
              dampenedReport = report
              dampenedReport.removeFirst()
              if isReportSafe(dampenedReport) {
                  return true
              }
          } else if ix == report.count - 1 {
              // just exclude the last element
              dampenedReport = report
              dampenedReport.removeLast()
              if isReportSafe(dampenedReport) {
                  return true
              }
          } else {
              // get everything up to but not including this element
              dampenedReport.append(contentsOf: report.prefix(upTo: ix))
              // and append everything after this element
              dampenedReport.append(contentsOf: report.suffix(from: ix + 1))
              if isReportSafe(dampenedReport) {
                  return true
              }
          }
      }
      return false
  }
}
