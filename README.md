# iosevka-n

Custom [Iosevka](https://typeof.net/Iosevka/) build pipeline.
Each release ships 6 TTF tarballs: 3 families (`iosevka-n`, `iosevka-n-term`, `iosevka-n-quasi-proportional`) in hinted and unhinted variants.

Consumed by [`nix-config/pkgs/iosevka-n`](https://github.com/nbetm/nix-config/tree/main/pkgs/iosevka-n).

## Trigger a build

```bash
gh workflow run build.yml                               # uses default iosevka_version
gh workflow run build.yml -f iosevka_version=v33.4.0    # override upstream tag
gh run watch                                            # follow the run
```

Releases are tagged `<iosevka_version>-<short_sha>` (e.g. `v33.3.3-a1b2c3d`).

## Tarball layout

Each tarball is flat: `.ttf` files at the root, no nested directory.
Two variants per family:

- `<family>-<version>.tar.gz`: hinted. Default, best for Windows/Linux at standard DPI.
- `<family>-unhinted-<version>.tar.gz`: unhinted. Preferred on macOS and high-DPI displays.

If you're not sure which, grab the hinted one.

```
$ tar -tzf iosevka-n-v33.3.3.tar.gz | head -3
./iosevka-n-Bold.ttf
./iosevka-n-BoldItalic.ttf
./iosevka-n-Italic.ttf
```

## Local build

```bash
nix develop
bash scripts/build-family.sh iosevka-n v33.3.3
bash scripts/package-family.sh iosevka-n v33.3.3 hinted
bash scripts/package-family.sh iosevka-n v33.3.3 unhinted
ls dist/iosevka-n-v33.3.3.tar.gz dist/iosevka-n-unhinted-v33.3.3.tar.gz
```

## Bump the nix-config pin

In `nix-config`, edit `pkgs/iosevka-n/sources.nix`:

1. Set `release` to the new tag.
1. Set each entry's `sha256` to `"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="`.
1. Build all six with `--keep-going` to catch every hash mismatch at once:
   ```bash
   nix build --keep-going \
     .#nixosConfigurations.aura.pkgs.iosevka-n{,-term,-quasi-proportional}{,-unhinted}
   ```
1. Paste each `got: sha256-...` from the error output back into `sources.nix`.

## Licensing

- Iosevka fonts (including these tarballs) are **OFL-1.1**, same as upstream `be5invis/iosevka`. Each tarball bundles `OFL.txt`.
- This repository's scripts and workflow are **MIT** (see `LICENSE`).
- The `get-all-families-in-private-build-plan/` helper is vendored from `be5invis/iosevka-custom-build-demo`, also **MIT** (see `THIRD_PARTY_LICENSES.md`).
