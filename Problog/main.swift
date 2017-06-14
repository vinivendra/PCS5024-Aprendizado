import Darwin
import Dispatch
import Foundation

extension Array {
	mutating func shuffle() {
		for i in indices.dropLast() {
			let interval = endIndex - i
			let rand = Int(arc4random()) % interval
			let j = i + rand
			let aux = self[i]
			self[i] = self[j]
			self[j] = aux
		}
	}

	func shuffled() -> Array {
		var copy = self
		copy.shuffle()
		return copy
	}
}

extension Array where Element: Comparable {
	struct BoxPlot {
		let minimum: Element
		let firstQuartile: Element
		let median: Element
		let thirdQuartile: Element
		let maximum: Element
	}

	var boxPlot: BoxPlot {
		return self.sorted().sortedBoxPlot
	}

	var sortedBoxPlot: BoxPlot {
		precondition(!self.isEmpty)

		let count = self.count
		return BoxPlot(minimum: self[0],
		               firstQuartile: self[count / 4],
		               median: self[count / 2],
		               thirdQuartile: self[3 * count / 4],
		               maximum: self[count - 1])
	}
}

typealias Datapoint = (Int, Int, Int, Int, Int, Int)

let dataFile = "/Users/vini/Desktop/Problog/Problog/learningTest.csv"

func factorToInt(_ string: String) -> Int {
	switch string {
	case "a": return 0
	case "b": return 1
	case "c": return 2
	case "d": return 3
	case "e": return 4
	case "f": return 5
	default:
		assertionFailure()
		return -1
	}
}

func loadData() -> [Datapoint] {
	let contents = try! String(
		contentsOfFile: dataFile).components(separatedBy: "\n")

	return contents.flatMap {
		(line: String) -> Datapoint? in

		let items = line.components(separatedBy: ",")
		guard items.count == 6 else { return nil }
		return (factorToInt(items[0]),
		        factorToInt(items[1]),
		        factorToInt(items[2]),
		        factorToInt(items[3]),
		        factorToInt(items[4]),
		        factorToInt(items[5]))
	}
}

let maxValues = (3, 3, 3, 3, 3, 2)

func dataToEvidenceString(_ data: ArraySlice<Datapoint>) -> String {
	var result = ""
	for point in data {
		for attribute in 0..<maxValues.0 {
			if attribute == point.0 {
				result += "evidence(a(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(a(\(attribute + 1)), false).\n"
			}
		}
		for attribute in 0..<maxValues.1 {
			if attribute == point.1 {
				result += "evidence(b(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(b(\(attribute + 1)), false).\n"
			}
		}
		for attribute in 0..<maxValues.2 {
			if attribute == point.2 {
				result += "evidence(c(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(c(\(attribute + 1)), false).\n"
			}
		}
		for attribute in 0..<maxValues.3 {
			if attribute == point.3 {
				result += "evidence(d(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(d(\(attribute + 1)), false).\n"
			}
		}
		for attribute in 0..<maxValues.4 {
			if attribute == point.4 {
				result += "evidence(e(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(e(\(attribute + 1)), false).\n"
			}
		}
		for attribute in 0..<maxValues.5 {
			if attribute == point.5 {
				result += "evidence(f(\(attribute + 1)), true).\n"
			} else {
				result += "evidence(f(\(attribute + 1)), false).\n"
			}
		}

		result += "---\n"
	}

	return result
}

let evidenceFile = "/Users/vini/Desktop/Problog/Problog/evidence.pl"

///////////////////////////////////////////////////////////////////
let data = loadData().shuffled()

var i = 0
let setSize = 1
//while true {
	let learningRange = (i * setSize * 10)..<((i+1) * setSize * 10 - setSize)
	let learningData = data[learningRange]
	let string = dataToEvidenceString(learningData)

	writeString(string, toFileAtPath: evidenceFile)

	print("Starting command...")
	let start = DispatchTime.now()

	runShellCommand("/usr/local/bin/problog lfi /Users/vini/Desktop/Problog/Problog/model.pl /Users/vini/Desktop/Problog/Problog/evidence.pl -o /Users/vini/Desktop/Problog/Problog/learned\(i).pl")

	let end = DispatchTime.now()
	let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
	let timeInterval = Double(nanoTime) / 1_000_000_000
	print("Done!")
	print(timeInterval)

	i += 1
//}
