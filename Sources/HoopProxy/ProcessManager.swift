import Foundation

actor ProcessManager {
    func connectToAll(connections: [String: Int]) async throws -> [Process] {
        print("Connecting...")
        var processes: [Process] = []
        
        for (connection, port) in connections {
            let process = Process()
            process.executableURL = URL(filePath: "/usr/bin/env")
            process.arguments = ["hoop", "connect", connection, "-p", String(port)]
            processes.append(process)
        }
        
        return processes
    }
    
    func waitForEOF(input: FileHandle = FileHandle.standardInput) async throws {
        await withTaskCancellationHandler(operation: {
            var data: Data
            repeat {
                data = input.availableData  // Fetch available data continuously
                if !data.isEmpty, let line = String(data: data, encoding: .utf8) {
                    print("Received line: \(line.trimmingCharacters(in: .whitespacesAndNewlines))")
                }
            } while !data.isEmpty  // Stop when no more data is available (EOF)
        }, onCancel: {
            print("EOF or cancellation received")
        })
    }

}
