import Foundation

@discardableResult
func runShellCommand(_ command: String) -> (output: String, status: Int32) {
	let arguments = command.components(separatedBy: " ")
	let pipe = Pipe()
	let task = Process()
	task.launchPath = "/usr/bin/env"
	task.arguments = arguments
	task.standardOutput = pipe
	task.launch()
	task.waitUntilExit()
	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let string = String(data: data, encoding: .utf8) ?? ""

	return (string, task.terminationStatus)
}

func writeString(_ contents: String, toFileAtPath filePath: String) {
	if FileManager.default.fileExists(atPath: filePath) {
		try? FileManager.default.removeItem(atPath: filePath)
	}

	let success = FileManager.default.createFile(
		atPath: filePath,
		contents: nil)
	guard success else { return }

	guard let data = contents.data(using: .utf8),
		let file = FileHandle(forUpdatingAtPath: filePath)
		else { return }

	file.seek(toFileOffset: 0)
	file.write(data)
	file.closeFile()
}
