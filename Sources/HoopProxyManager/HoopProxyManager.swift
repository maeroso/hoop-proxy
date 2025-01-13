import ArgumentParser

@main
struct HoopProxyManager: AsyncParsableCommand {
    nonisolated(unsafe) static var configuration = CommandConfiguration(
        commandName: "-manager",
        abstract: "A CLI tool for managing Hoop proxy connections",
        subcommands: [ConnectCommand.self]
    )
}
