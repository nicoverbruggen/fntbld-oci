# fntbld-oci

A Debian-based container image with font-building tools pre-installed.

The image contains no project-specific files. Mount or clone your font project into `/build` at runtime.

## FontForge

FontForge is **built from source** rather than installed from `apt`, because the
Debian/Ubuntu packages are pinned to the old `20230101` release. The current
image ships FontForge **`20251009`**, exposing both the native `fontforge` CLI
and the importable Python extension (`import fontforge`), built against the
image's Python 3.12 so the API is available at runtime.

The build is headless (`-DENABLE_GUI=OFF`) and uses a multi-stage Dockerfile: the
C/C++ toolchain lives only in the builder stage and is discarded, and the
installed libraries are stripped, keeping the final image lean.

To bump the version, change the `FONTFORGE_VERSION` build arg (a
[FontForge release tag](https://github.com/fontforge/fontforge/releases)):

```bash
podman build --build-arg FONTFORGE_VERSION=20251009 -t fntbld-oci .
```

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
