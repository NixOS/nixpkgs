{ stdenv, pkgs, lib, akkuPackages, xorg, chibi }:
let
  inherit (lib) addMetaAttrs;
  broken = addMetaAttrs { broken = true; };
  skipTests = pkg: old: { doCheck = false; };
  };
  in
  {
  chez-srfi = pkg: old: {
    preCheck = ''
      SKIP='
      multi-dimensional-arrays.sps
      time.sps
      tables-test.ikarus.sps
      lazy.sps
      '
    '';
  };
  akku-r7rs = pkg: old: {
    preBuild = ''
      # tests aren't exported modules
      rm -rf tests
    '';
  };

  # broken tests
  xitomatl = skipTests;
  chibi-optional = skipTests;
  ufo-threaded-function = skipTests;

  # unmerged metadata errors, cares about: lib/scheme-libs/akku/metadata.sls for some reason
  # needs further investigation
  chibi-diff = skipTests;

  # unsupported schemes, it seems.
  loko-srfi = broken;
  ac-d-bus = broken;
  }
