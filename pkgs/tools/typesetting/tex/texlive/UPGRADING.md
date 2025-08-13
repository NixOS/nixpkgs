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

### Upgrading the ConTeXt binaries

ConTeXt in TeX Live is packaged as described
[here](https://github.com/gucci-on-fleek/context-packaging). With every update
to the ConTeXt package, the LuaMetaTeX compiler also needs to be updated. For
this, we fetch the source from the releases of the above repo. Make sure to
update this in `texlive.bin.context`, when updating TeX Live.

### Updating the licensing information

The license of each package in texlive is automatically extracted from texlive's
texlive.tlpdb into tlpdb.nix. The combined licenses of the schemes is stored
separately in `default.nix` and must be kept in sync with the licenses of the
actual contents of these schemes. Whether this is the case can be verified with the
`pkgs.tests.texlive.licenses` test. In case of a mismatch, copy the “correct”
license lists reported by the test into `default.nix`.

### Running the testsuite

There are a some other useful tests that haven't been mentioned before. Build them with
```
nix-build ../../../../.. -A tests.texlive --no-out-link
```


### Commit changes

Commit the updated `tlpdb.nix` and `fixed-hashes.nix` to the repository with
a message like

> texlive: 2022-final -> 2023.20230401

Please make sure to follow the [CONTRIBUTING](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md)
guidelines.

## Reviewing the bin containers

Most `tlType == "bin"` containers consist of links to scripts distributed in
`$TEXMFDIST/scripts` with a number of patches applied within `default.nix`.

At each upgrade, please run the tests `tests.texlive.shebangs` to verify that
all shebangs have been patched and in case add the relevant interpreters, and
use `tests.texlive.binaries` to check if basic execution of all binaries works.

Please review manually all binaries in the `broken` and `ignored` lists of
`tests.texlive.binaries` at least once for major TeX Live release.

Since the tests cannot catch all runtime dependencies, you should grep the
`$TEXMFDIST/scripts` folder for common cases, for instance (where `$scripts`
points to the relevant folder of `scheme-full`):
- Calls to `exec $interpreter`
  ```
  grep -IRS 'exec ' "$TEXMFDIST/scripts" | cut -d: -f2 | sort -u | less -S
  ```
- Calls to Ghostscripts (see `needsGhostscript` in `combine.nix`)
  ```
  grep -IR '\([^a-zA-Z]\|^\)gs\( \|$\|"\)' "$TEXMFDIST"/scripts
  grep -IR 'rungs' "$TEXMFDIST"
  ```

As a general rule, if a runtime dependency as above is essential for the core
functionality of the package, then it should be made available in the bin
containers (by patching `PATH`), or in `texlive.combine` (as we do for
Ghostscript). Non-essential runtime dependencies should be ignored if they
increase the closure substantially.
