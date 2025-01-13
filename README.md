# Hoop Proxy Manager

Hoop Proxy Manager is an application designed to manage Hoop proxy connections. It uses the Hoop CLI to authenticate and make connections.

## Requirements
- macOS 13 Ventura or later
- Ubuntu 20.04 or later
- [Hoop CLI](https://hoop.dev/docs/getting-started/cli)

## Installation

You can just download a binary from the [latest release available](https://github.com/maeroso/hoop-proxy-manager/releases).

## Usage

### Hoop CLI prior configuration
You'll need Hoop CLI to have been logged in at least once, to do this see [this documentation](https://hoop.dev/docs/getting-started/cli#authenticate).

After you have logged in, please create or edit the `~/.hoop/connections.toml` file with the following format:
```toml
[connections]
# your-hoop-connection-id = port-int-number
an-example-hoop-pg-connection = 5432
another-example-hoop-pg-connection = 5433
```

### Running the proxy
To run the proxy, execute:
```sh
./HoopProxyManager connect
```

It will start hoop cli login to renew the token and then start the proxy with the connections defined in the `~/.hoop/connections.toml` file.

## Development

## Requirements
- Swift 6 or later

### Building
To build the project, run:
```sh
swift build
```
### Testing
To run the tests, execute:
```sh
swift test
```

### Continuous Integration
This project uses GitHub Actions for continuous integration. The workflow is defined in `build-and-release.yml`.

### Contributing
Contributions are welcome! Please open an issue or submit a pull request.

### License
This project is licensed under the GNU LGPL License. See the LICENSE file for details.

