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

To save disk space and prevent unnecessary rebuilds, texlive packages are built
as fixed-output derivations whose hashes are contained in `fixedHashes.nix`.

Updating the list of fixed hashes requires a local build of *all* packages,
which is a resource-intensive process:


```bash
# move fixedHashes away, otherwise build will fail on updated packages
mv fixedHashes.nix fixedHashes-old.nix
# start with empty fixedHashes
echo '{}' > fixedHashes.nix

nix-build ../../../../.. -Q --no-out-link -A texlive.scheme-full.pkgs | ./fixHashes.awk > ./fixedHashes-new.nix

mv fixedHashes-new.nix fixedHashes.nix
```

### Commit changes

Commit the updated `tlpdb.nix` and `fixedHashes.nix` to the repository.
