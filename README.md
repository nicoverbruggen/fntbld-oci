# fntbld-oci

A Debian-based container image with font-building tools pre-installed:

- **FontForge** — scriptable font editor
- **ttfautohint** — auto-hinter for TrueType fonts
- **fontTools** — Python library for manipulating font files
- **OpenType Sanitizer (OTS)** — validator/sanitizer for OTF/TTF/WOFF/WOFF2 fonts

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
