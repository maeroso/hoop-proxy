import Foundation
import ArgumentParser

struct ConnectCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "connect",
        abstract: "Connect to all configured Hoop instances"
    )
    
    @Flag(name: .shortAndLong, help: "Run in verbose mode")
    var verbose = false
    
    func run() async throws {
        let configManager = ConfigManager()
        let processManager = ProcessManager()
        
        if verbose { print("Starting Hoop CLI...") }
        
        do {
            try await configManager.checkHoop()
            try await configManager.checkAuth()
            let connections = try await configManager.readConnectionsFile()
            
            let processes = try await processManager.connectToAll(connections: connections)
            
            if verbose { print("All connections established. Press Ctrl+D to exit.") }
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try await processManager.waitForEOF()
                }
                
                for process in processes {
                    group.addTask {
                        try process.run()
                    }
                }
                
                try await group.waitForAll()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
}
