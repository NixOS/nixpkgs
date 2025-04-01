# wfs-tools

Tools for working with Wii U WFS filesystem.

## Usage

The package provides several tools:

- `wfs-fuse`: Mount WFS filesystems using FUSE
- `wfs-extract`: Extract files from WFS images
- `wfs-info`: Get information about WFS images
- `wfs-reencryptor`: Reencrypt WFS images
- `wfs-file-injector`: Inject files into WFS images

## Example

To mount a WFS filesystem:

```bash
wfs-fuse <device_file> <mountpoint> [--type <file type>] [--otp <otp_path> [--seeprom <sseeprom_path>]]
```

## License

MIT License
