# This test *must* be run prior to releasing any build of either stdenv or the
# gcc that it exports!  This check should also be part of CI for any PR that
# causes a rebuild of `stdenv.cc`.
#
# When we used gcc's internal bootstrap it did this check as part of (and
# serially with) the gcc derivation.  Now that we bootstrap externally this
# check can be done in parallel with any/all of stdenv's referrers.  But we
# must remember to do the check.
#

{ lib
, stdenv
, runCommand
, overrideCC
, wrapCCWith
}:

let
  inherit (stdenv.cc) cc;
in

assert cc.isGNU;

# Rebuild gcc using the "final" stdenv.
let
  rebuiltCC = (cc.override {
    reproducibleBuild = true;
    profiledCompiler = false;
    stdenv = overrideCC stdenv (wrapCCWith {
      inherit cc;
    });
  }).overrideAttrs (_: {
    # TODO: do we really have to set random seed? This likely won’t work with
    # content-addressed derivations, and also GCC expects random seed to be
    # different for each file (but that is an issue with stdenv in general).
    # https://gcc.gnu.org/onlinedocs/gcc-14.1.0/gcc/Developer-Options.html#index-frandom-seed
    # >The string should be different for every file you compile.
    NIX_OUTPATH_USED_AS_RANDOM_SEED = cc.out;
  });

  cmdArgs = {
    checksumBefore = cc.checksum;
    checksumAfter = rebuiltCC.checksum;
    meta.platforms = lib.platforms.linux;
  };
in
runCommand "gcc-stageCompare" cmdArgs ''
  diff -sr "$checksumBefore"/checksums "$checksumAfter"/checksums
  touch $out
''
