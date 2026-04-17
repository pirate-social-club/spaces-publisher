# spaces-publisher

[Latest release](https://github.com/pirate-social-club/spaces-publisher/releases/latest) | [Install guide](./INSTALL.md)

`spaces-publisher` is a standalone CLI for publishing native Spaces website records to Fabric.

It is designed for Space holders who want to keep wallet material local while publishing signed SIP-7 `Txt` records such as:

- `web` for the canonical website target
- `freedom` for a Freedom-specific override

It can:

- resolve a Space and inspect its current website records
- inspect a local `space-cli exportwallet` file and match it to the live Space root
- publish or clear `web` / `freedom` records with locally derived signing keys
- dry-run a publish before broadcasting anything

## Security model

`space-cli exportwallet` contains a private descriptor with secret xprv material.

- Treat the wallet export as wallet-equivalent.
- Keep it on your trusted machine.
- Do not upload it to a VPS.
- Use remote servers only for read-only resolve operations.

## Install

### Go install

```bash
go install github.com/pirate-social-club/spaces-publisher@latest
```

### Build from source

```bash
git clone https://github.com/pirate-social-club/spaces-publisher
cd spaces-publisher
go build ./...
```

### Prebuilt binaries

Tagged releases publish archives for:

- Linux `amd64`
- macOS `arm64`

Each release also includes a `checksums.txt` file.

## CI / releases

This repo uses standard GitHub Actions for CI and tagged releases.

- `ci.yml` runs format check, build, and test on pushes and PRs
- `release.yml` builds cross-platform binaries on `v*` tags and uploads them to GitHub Releases

If you use Blacksmith as your GitHub Actions runner backend, you can swap the `runs-on` labels in the workflow files without changing the release logic.

## Usage

```bash
spaces-publisher resolve @pirate
spaces-publisher inspect-wallet @pirate --wallet-export ~/safe/pirate-wallet.json
spaces-publisher publish @pirate --wallet-export ~/safe/pirate-wallet.json --web https://pirate.sc/ --dry-run
spaces-publisher publish @pirate --wallet-export ~/safe/pirate-wallet.json --web https://pirate.sc/ --freedom https://pirate/
spaces-publisher clear @pirate --wallet-export ~/safe/pirate-wallet.json --key freedom
```

You can also set the wallet export once:

```bash
export SPACES_WALLET_EXPORT=~/safe/pirate-wallet.json
spaces-publisher inspect-wallet @pirate
```

### Platform notes

- Linux builds are produced on Linux runners.
- macOS builds are currently Apple Silicon only because upstream `libveritas-go` currently ships `darwin-arm64` artifacts but not `darwin-amd64`.

Windows is not released yet because upstream `libveritas-go v0.1.1` still emits an invalid Windows `#cgo LDFLAGS` path during native builds.

This repo does not use Linux cross-compilation for Windows/macOS because `libveritas-go` uses cgo and native platform libraries.

## How it signs

When using `--wallet-export`, the tool:

1. Resolves the current Space root through Fabric.
2. Reads the private descriptor from the exported wallet JSON.
3. Scans the external descriptor branch `/0/*`.
4. Derives candidate child keys and tap-tweaks them.
5. Matches the derived x-only pubkey against the current live root pubkey.
6. Uses the matched tweaked secret key to sign the record update locally.

No wallet secret material is sent to a remote server.

## Record convention

This tool uses native SIP-7 `Txt` records:

- `Txt("web", ["https://example.com/"])`
- `Txt("freedom", ["https://example/"])`

The first string value for each key is treated as authoritative.

## Commands

### `resolve`

Resolve a handle through Fabric and print current `web` / `freedom` records.

### `inspect-wallet`

Match a local wallet export against a live Space root and print safe signer metadata:

- `matched_index`
- `matched_pubkey`
- `descriptor_path`
- `wallet_label`
- `wallet_blockheight`

### `publish`

Publish `web` / `freedom` records.

Useful flags:

- `--wallet-export`
- `--secret-key`
- `--web`
- `--freedom`
- `--dry-run`
- `--max-index`

`--secret-key` is an advanced path and expects the already tap-tweaked 32-byte BIP-340 secret key, not an xprv or untweaked child key.

### `clear`

Remove one or more target keys from the published record set.

## Relay configuration

Optional environment:

- `SPACES_WALLET_EXPORT`
- `SPACES_SECRET_KEY_HEX`
- `SPACES_FABRIC_SEEDS`

You can also pass `--seeds`, `--trust-id`, and `--dev-mode` directly on commands.

## Notes on vendored `fabric-go`

This repo currently vendors a patched `fabric-go` under `third_party/fabric-go` so builds are reproducible without depending on a local checkout.

The patch is a compatibility fix for the current `libveritas-go` API:

```diff
- rs := libveritas.NewRecordSet(*z.Records)
+ rs := libveritas.NewRecordSet(z.Records)
```

Once upstream `fabric-go` includes that fix, the vendored copy can be removed.

## License

AGPL-3.0
