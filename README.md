# fntbld-oci

A Debian-based container image with font-building tools pre-installed:

- **FontForge**, which is a scriptable font editor
- **ttfautohint**, which is an auto-hinter for TrueType fonts
- **fontTools**, which is a Python library for manipulating font files
- **brotli**, which is a data compression algorithm required for generating webfonts
- **OpenType Sanitizer (OTS)**, which is a validator/sanitizer for OTF/TTF/WOFF/WOFF2 fonts
- **NodeJS 20.x**, which is required for running Actions via a custom Git Forge

The image contains no project-specific files. Mount or clone your font project into `/build` at runtime.

## Build locally

```bash
podman build -t fntbld-oci .
```

## Pull from GitHub Container Registry

```bash
podman pull ghcr.io/nicoverbruggen/fntbld-oci:latest
```

## Usage

From your font project directory:

```bash
podman run --rm -v .:/build ghcr.io/nicoverbruggen/fntbld-oci python3 build.py
```

## Debugging

To rebuild and get a shell inside the container:

```bash
podman build -t fntbld-oci . && podman run --rm -it fntbld-oci sh
```
