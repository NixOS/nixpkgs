{
  lib,
  fetchurl,
  runCommand,
  version,
}:

let
  # NetBSD ships each release's source as a handful of "sets": gzipped tars that
  # all unpack into `usr/src`. We take three of them:
  #
  #   src       everything outside `sys`, `share` and the imported GNU/X11 trees
  #   syssrc    the kernel -- `sys`, and the per-arch `conf` directories
  #   sharesrc  `share`, which carries `share/mk`, i.e. the build system itself
  #
  # `gnusrc` (the imported gcc/binutils) and `xsrc` (X11) are deliberately left
  # out. Nothing in this package set builds either, and together they are a
  # further ~450MB of download.
  #
  # These hashes are transcribed from the `SHA512` file NetBSD publishes beside
  # the sets, so the pin is to upstream's own checksums rather than to a digest
  # we generated ourselves:
  #
  #   https://cdn.NetBSD.org/pub/NetBSD/NetBSD-11.0/source/sets/SHA512
  #
  # That file lists them in hex; `nix hash convert --to base16 <hash>` turns
  # the ones below into the same form for comparison.
  fetchSet =
    name: hash:
    fetchurl {
      url = "https://cdn.NetBSD.org/pub/NetBSD/NetBSD-${version}/source/sets/${name}.tgz";
      inherit hash;
    };

  sets = [
    (fetchSet "src" "sha512-maj5YgIpDOID2YOWMF864eOLSWY7EhBEfLgtBe4XF5aa22EB2rXwYFDp75gb1u+3mK4bLo5/AHm6VIbaTKgvzA==")
    (fetchSet "syssrc" "sha512-MY1FHsyDdJYH1USBmMAmY+pfC39Mx0+1ZXR/hu6te2a1gJo33u4hncbdsuXuMy0cu5TBpOnbY2IMOr11hvswVw==")
    (fetchSet "sharesrc" "sha512-XmfISWLoBl8LiIuz2PXWwUCgCHGh+XxXrCQz4nKwyauxwUi1UVmVyXQ5D3t12S5jR0EvRw3iOohX8ypiu08Azw==")
  ];
in

runCommand "netbsd-source-${version}" { } (
  # Every set is rooted at `usr/src`; strip that so the result has `lib`,
  # `sys`, `share` and friends directly at the top, which is the layout the
  # rest of this package set indexes into. `CVS` bookkeeping directories are
  # an artifact of how the sets are cut and are of no use to us.
  ''
    mkdir -p "$out"
    for set in ${lib.escapeShellArgs sets}; do
      tar -xzf "$set" -C "$out" --strip-components=2 --exclude CVS usr/src
    done
  ''
  # The sets ship the generated `configure` scripts without the executable bit.
  # NetBSD's own build never noticed, because it invokes them as
  # `${HOST_SH} configure`; stdenv's `configurePhase` only runs `./configure`
  # when it is executable, and otherwise reports "no configure script, doing
  # nothing" and leaves the build to fail later on a missing generated file.
  # `fetchcvs` used to preserve the bit, so this is a difference we have to
  # make up for rather than a change in intent.
  + ''
    find "$out" -type f -name configure -exec chmod +x {} +
  ''
)
