{ lib, pkgs, stdenv, newScope, nim, fetchFromGitHub }:

lib.makeScope newScope (self:
  let callPackage = self.callPackage;
  in {
    inherit nim;
    nim_builder = callPackage ../development/nim-packages/nim_builder { };
    buildNimPackage =
      callPackage ../development/nim-packages/build-nim-package { };
    fetchNimble = callPackage ../development/nim-packages/fetch-nimble { };

    astpatternmatching =
      callPackage ../development/nim-packages/astpatternmatching { };

    bumpy = callPackage ../development/nim-packages/bumpy { };

    chroma = callPackage ../development/nim-packages/chroma { };

    c2nim = callPackage ../development/nim-packages/c2nim { };

    docopt = callPackage ../development/nim-packages/docopt { };

    flatty = callPackage ../development/nim-packages/flatty { };

    frosty = callPackage ../development/nim-packages/frosty { };

    hts-nim = callPackage ../development/nim-packages/hts-nim { };

    jester = callPackage ../development/nim-packages/jester { };

    jsonschema = callPackage ../development/nim-packages/jsonschema { };

    jsony = callPackage ../development/nim-packages/jsony { };

    karax = callPackage ../development/nim-packages/karax { };

    lscolors = callPackage ../development/nim-packages/lscolors { };

    markdown = callPackage ../development/nim-packages/markdown { };

    nimcrypto = callPackage ../development/nim-packages/nimcrypto { };

    nimbox = callPackage ../development/nim-packages/nimbox { };

    nimsimd = callPackage ../development/nim-packages/nimsimd { };

    noise = callPackage ../development/nim-packages/noise { };

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

    tempfile = callPackage ../development/nim-packages/tempfile { };

    ui = callPackage ../development/nim-packages/ui { inherit (pkgs) libui; };

    unicodedb = callPackage ../development/nim-packages/unicodedb { };

    unicodeplus = callPackage ../development/nim-packages/unicodeplus { };

    vmath = callPackage ../development/nim-packages/vmath { };

    zippy = callPackage ../development/nim-packages/zippy { };

  })
