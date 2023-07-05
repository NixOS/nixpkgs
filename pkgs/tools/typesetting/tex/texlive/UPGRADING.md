# Notes on maintaining/upgrading

## Upgrading `texlive.bin`

`texlive` contains a few binaries, defined in `bin.nix` and released once a year.

In order to reduce closure size for users who just need a few of them, we split it into
packages such as `core`, `core-big`, `xdvi`, etc. This requires making assumptions
about dependencies between the projects that may change between releases; if
you upgrade you may have to do some work here.

## Updating the package set

`texlive` contains several thousand packages from CTAN, defined in `tlpdb.nix`.

The CTAN mirrors are not version-controlled and continuously moving,
with more than 100 updates per month.

To create a consistent and reproducible package set in nixpkgs, we generate nix
expressions for all packages in TeX Live at a certain day.

To upgrade the package snapshot, follow this process.

### Upgrade package information from texlive package database

Update `version` in `default.nix` with the day of the new snapshot, the new TeX
Live year, and the final status of the snapshot. Then update
`texlive.tlpdbxz.hash` to match the new hash of `texlive.tlpdb.xz` and run

```bash
nix-build ../../../../.. -A texlive.tlpdb.nix --no-out-link
```

This will download either the daily or the final snapshot of the TeX Live
package database `texlive.tlpdb.xz` and extract the relevant package info
(including version numbers and sha512 hashes) for the selected upstream
distribution.

Finally, replace `tlpdb.nix` with the generated file. Note that if the
`version` info does not match the metadata of `tlpdb.nix` (as found in the
`00texlive.config` package), TeX Live packages will not evaluate.

The test `pkgs.tests.texlive.tlpdbNix` verifies that the file `tlpdb.nix`
in Nixpkgs matches the one that generated from `texlive.tlpdb.xz`.

### Build packages locally and generate fix hashes

To prevent unnecessary rebuilds, texlive packages are built as fixed-output
derivations whose hashes are contained in `fixed-hashes.nix`.

Updating the list of fixed hashes requires a local build of all new packages,
which is a resource-intensive process. First build the hashes for the new
packages. Consider tweaking the `-j` option to maximise core usage.

```bash
nix-build generate-fixed-hashes.nix -A newHashes -j 8
```

Then build the Nix expression containing all the hashes, old and new. This step
cannot be parallelized because it relies on 'import from derivation'.

```bash
nix-build generate-fixed-hashes.nix -A fixedHashesNix
```

Finally, copy the result to `fixed-hashes.nix`.

**Warning.** The expression `fixedHashesNix` reuses the *previous* fixed hashes
when possible. This is based on two assumptions: that `.tar.xz` archives with
the same names remain identical in time (which is the intended behaviour of
CTAN and the various mirrors) and that the build recipe continues to produce
the same output. Should those assumptions not hold, remove the previous fixed
hashes for the relevant package, or for all packages.

### Commit changes

Commit the updated `tlpdb.nix` and `fixed-hashes.nix` to the repository with
a message like

> texlive: 2022-final -> 2023.20230401

Please make sure to follow the [CONTRIBUTING](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md)
guidelines.
