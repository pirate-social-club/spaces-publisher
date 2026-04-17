# Install

## Download a release binary

Current release artifacts are published on GitHub Releases:

- `spaces-publisher-vX.Y.Z-linux-amd64.tar.gz`
- `spaces-publisher-vX.Y.Z-windows-amd64.zip`
- `spaces-publisher-vX.Y.Z-darwin-arm64.tar.gz`
- `checksums.txt`

Example:

```bash
curl -LO https://github.com/pirate-social-club/spaces-publisher/releases/latest/download/spaces-publisher-v0.1.4-linux-amd64.tar.gz
curl -LO https://github.com/pirate-social-club/spaces-publisher/releases/latest/download/checksums.txt
sha256sum -c checksums.txt --ignore-missing
tar -xzf spaces-publisher-v0.1.4-linux-amd64.tar.gz
cd spaces-publisher-v0.1.4-linux-amd64
./spaces-publisher --help
```

## Go install

```bash
go install github.com/pirate-social-club/spaces-publisher@latest
```

## Windows

On Windows, download the `windows-amd64.zip` release asset and run `spaces-publisher.exe`.

## macOS

Current macOS release assets target Apple Silicon (`darwin-arm64`).

## First run

Point the tool at a local `space-cli exportwallet` file:

```bash
export SPACES_WALLET_EXPORT=~/safe/pirate-wallet.json
spaces-publisher inspect-wallet @pirate
spaces-publisher publish @pirate --web https://pirate.sc/ --dry-run
```

## Security

- `space-cli exportwallet` contains a private descriptor with secret xprv material
- keep it on your trusted machine
- do not upload it to a VPS
- use remote servers only for read-only resolve operations
