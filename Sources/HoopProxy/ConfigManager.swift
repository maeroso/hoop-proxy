import Foundation
import TOMLKit

actor ConfigManager {
    let hoopConfigDir: URL
    private static let defaultHoopConfigDir = URL(filePath: NSHomeDirectory()).appending(path: ".hoop")
    
    init(hoopConfigDir: URL = ConfigManager.defaultHoopConfigDir) {
        self.hoopConfigDir = hoopConfigDir
    }
    
    func checkHoop() async throws {
        print("Checking hoop installation...", terminator: " ")
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/env")
        process.arguments = ["hoop", "version"]
        
        do {
            try process.run()
            print("✅")
        } catch {
            throw RuntimeError("hoop is not installed. Please install hoop before running this script.")
        }
    }
    
    func checkAuth() async throws {
        print("Checking hoop authentication...", terminator: " ")
        let configPath = hoopConfigDir.appending(path: "config.toml")
        
        if let contents = try? String(contentsOf: configPath) {
            if let config = try? TOMLTable(string: contents) {
                config["token"]?.string
            }
            return
        }
        
        
        
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/env")
        process.arguments = ["hoop", "login"]
        
        do {
            try process.run()
            if process.terminationStatus != 0 {
                throw RuntimeError("Login failed. Please try again.")
            }
        } catch {
            throw RuntimeError("Failed to run hoop login. Error: \(error)")
        }
    }
    
    func readConnectionsFile() async throws -> [String: Int] {
        print("Reading connections.toml...", terminator: " ")
        let connectionsPath = hoopConfigDir.appending(path: "connections.toml")
        
        guard let contents = try? String(contentsOf: connectionsPath) else {
            throw RuntimeError("connections.toml file not found. Please create one before running this script.")
        }
        
        var connections: [String: Int] = [:]
        let lines = contents.split(separator: "\n")
        
        for line in lines {
            let parts = line.split(separator: "=").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2, let port = Int(parts[1]) {
                connections[String(parts[0])] = port
            }
        }
        
        if connections.isEmpty {
            throw RuntimeError("No valid connections found in connections.toml.")
        }
        
        print("✅")
        return connections
    }
}
