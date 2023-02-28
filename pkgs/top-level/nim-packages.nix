{ lib, pkgs, stdenv, newScope, nim, fetchFromGitHub, buildPackages }:

lib.makeScope newScope (self:
  let callPackage = self.callPackage;
  in {
    inherit nim;
    nim_builder = callPackage ../development/nim-packages/nim_builder { };
    buildNimPackage =
      callPackage ../development/nim-packages/build-nim-package {
        inherit (buildPackages.buildPackages.nimPackages) nim_builder;
      };
    fetchNimble = callPackage ../development/nim-packages/fetch-nimble { };

    astpatternmatching =
      callPackage ../development/nim-packages/astpatternmatching { };

    asynctools = callPackage ../development/nim-packages/asynctools { };

    base32 = callPackage ../development/nim-packages/base32 { };

    base45 = callPackage ../development/nim-packages/base45 { };

    bumpy = callPackage ../development/nim-packages/bumpy { };

    c2nim = callPackage ../development/nim-packages/c2nim { };

    cbor = callPackage ../development/nim-packages/cbor { };

    chroma = callPackage ../development/nim-packages/chroma { };

    docopt = callPackage ../development/nim-packages/docopt { };

    flatty = callPackage ../development/nim-packages/flatty { };

    frosty = callPackage ../development/nim-packages/frosty { };

    getdns = callPackage ../development/nim-packages/getdns {
      inherit (pkgs) getdns; };

    hts-nim = callPackage ../development/nim-packages/hts-nim { };

    jester = callPackage ../development/nim-packages/jester { };

    jsonschema = callPackage ../development/nim-packages/jsonschema { };

    jsony = callPackage ../development/nim-packages/jsony { };

    karax = callPackage ../development/nim-packages/karax { };

    lscolors = callPackage ../development/nim-packages/lscolors { };

    markdown = callPackage ../development/nim-packages/markdown { };

    nimcrypto = callPackage ../development/nim-packages/nimcrypto { };

    nimbox = callPackage ../development/nim-packages/nimbox { };

    nimSHA2 = callPackage ../development/nim-packages/nimSHA2 { };

    nimsimd = callPackage ../development/nim-packages/nimsimd { };

    noise = callPackage ../development/nim-packages/noise { };

    npeg = callPackage ../development/nim-packages/npeg { };

    packedjson = callPackage ../development/nim-packages/packedjson { };

    pixie = callPackage ../development/nim-packages/pixie { };

    redis = callPackage ../development/nim-packages/redis { };

    redpool = callPackage ../development/nim-packages/redpool { };

    regex = callPackage ../development/nim-packages/regex { };

    rocksdb = callPackage ../development/nim-packages/rocksdb {
      inherit (pkgs) rocksdb;
    };

    sass = callPackage ../development/nim-packages/sass { };

    sdl2 = callPackage ../development/nim-packages/sdl2 { };

    segmentation = callPackage ../development/nim-packages/segmentation { };

    snappy =
      callPackage ../development/nim-packages/snappy { inherit (pkgs) snappy; };

    spry = callPackage ../development/nim-packages/spry { };

    spryvm = callPackage ../development/nim-packages/spryvm { };

    stew = callPackage ../development/nim-packages/stew { };

    supersnappy = callPackage ../development/nim-packages/supersnappy { };

    taps = callPackage ../development/nim-packages/taps { };

    tempfile = callPackage ../development/nim-packages/tempfile { };

    tkrzw = callPackage ../development/nim-packages/tkrzw { inherit (pkgs) tkrzw; };

    ui = callPackage ../development/nim-packages/ui { inherit (pkgs) libui; };

    unicodedb = callPackage ../development/nim-packages/unicodedb { };

    unicodeplus = callPackage ../development/nim-packages/unicodeplus { };

    vmath = callPackage ../development/nim-packages/vmath { };

    zippy = callPackage ../development/nim-packages/zippy { };

  })
