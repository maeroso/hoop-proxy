import ArgumentParser

@main
struct HoopProxy: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "hoop-proxy",
        abstract: "A CLI tool for managing Hoop proxy connections",
        subcommands: [ConnectCommand.self]
    )
}
