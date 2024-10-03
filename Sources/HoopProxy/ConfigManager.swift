import Foundation
import TOMLKit
import JWTKit

struct ExamplePayload: JWTPayload {
    var sub: SubjectClaim
    var exp: ExpirationClaim
    var admin: BoolClaim

    func verify(using _: some JWTAlgorithm) throws {
        try self.exp.verifyNotExpired()
    }
}

enum ConfigManagerError: Error {
    case loginFailed(String)
    case configReadFailed(String)
    case tokenVerificationFailed(String)
}

actor ConfigManager {
    let hoopConfigDir: URL
    private static let defaultHoopConfigDir = URL(filePath: NSHomeDirectory()).appending(path: ".hoop")
    
    init(hoopConfigDir: URL = ConfigManager.defaultHoopConfigDir) {
        self.hoopConfigDir = hoopConfigDir
    }
    
    func checkHoop() async throws {
        print("Checking hoop installation...")
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
    
    func login() throws {
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/env")
        process.arguments = ["hoop", "login"]
        
        do {
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                throw ConfigManagerError.loginFailed("Login failed. Please try again.")
            }
        } catch {
            throw ConfigManagerError.loginFailed("Failed to run hoop login. Error: \(error)")
        }
    }
    
    func checkAuth() async throws {
        print("Checking hoop authentication...", terminator: " ")
        let configPath = hoopConfigDir.appendingPathComponent("config.toml")
        
        guard let contents = try? String(contentsOf: configPath) else {
            throw ConfigManagerError.configReadFailed("Failed to read config file at \(configPath).")
        }
        
        guard let config = try? TOMLTable(string: contents) else {
            throw ConfigManagerError.configReadFailed("Failed to parse config file.")
        }
        
        guard let token = config["token"]?.string else {
            throw ConfigManagerError.configReadFailed("Token not found in config file.")
        }
        
        do {
            let _: ExamplePayload = try await JWTKeyCollection().verify(token)
        } catch {
            try self.login()
        }
    }
    
    func readConnectionsFile() async throws -> [String: Int] {
        print("Reading connections.toml...")
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
