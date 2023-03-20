# Notes on maintaining/upgrading

## Upgrading texlive.bin

texlive contains a few binaries, defined in bin.nix and released once a year.

In order to reduce closure size for users who just need a few of them, we split it into
packages such as core, core-big, xvdi, etc. This requires making assumptions
about dependencies between the projects that may change between releases; if
you upgrade you may have to do some work here.


## Updating the package set

texlive contains several thousand packages from CTAN, defined in pkgs.nix.

The CTAN mirrors are not version-controlled and continuously moving,
with more than 100 updates per month.

To create a consistent and reproducible package set in nixpkgs, we snapshot CTAN
and generate nix expressions for all packages in texlive at that point.

We mirror CTAN sources of this snapshot on community-operated servers and on IPFS.

To upgrade the package snapshot, follow this process:


### Snapshot sources and texlive package database

Mirror the current CTAN archive to our mirror(s) and IPFS (URLs in `default.nix`).
See https://tug.org/texlive/acquire-mirror.html for instructions.


### Upgrade package information from texlive package database

First, edit `default.nix` as follows.

If upgrading to a daily snapshot:
- change `snapshot.year`, `snapshot.month`, `snapshot.day`;
- ensure `urlPrefixes` uses the https://texlive.info/tlnet-archive mirror;
- ensure `texlive.extraVersion` uses the `snapshot` info.

If upgrading to a final release:
- upgrade `texlive.bin` first;
- ensure `urlPrefixes` uses the historic mirrors;
- ensure `texlive.extraVersion` is `"-final"`.

Then upgrade `tlpdb.hash` to match the new hash of `texlive.tlpdb.xz` and run

```bash
nix-build ../../../../.. -A texlive.tlpdb-nix --no-out-link
```

This will download the daily snapshot of the CTAN package database
`texlive.tlpdb.xz` and extract the relevant package info (including version
numbers and sha512 hashes) for the selected upstream distribution. Then replace
`tlpdb.nix` with the generated file.

The test `pkgs.tests.texlive.tlpdb-nix` verifies that the file `tlpdb.nix`
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

Commit the updated `pkgs.nix` and `fixedHashes.nix` to the repository.
