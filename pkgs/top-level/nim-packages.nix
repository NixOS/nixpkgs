{ lib, pkgs, stdenv, newScope, nim, fetchFromGitHub }:

lib.makeScope newScope (self:
  let callPackage = self.callPackage;
  in {
    inherit nim;
    nim_builder = callPackage ../development/nim-packages/nim_builder { };
    buildNimPackage =
      callPackage ../development/nim-packages/build-nim-package { };
    fetchNimble = callPackage ../development/nim-packages/fetch-nimble { };

    bumpy = callPackage ../development/nim-packages/bumpy { };

    chroma = callPackage ../development/nim-packages/chroma { };

    flatty = callPackage ../development/nim-packages/flatty { };

    nimsimd = callPackage ../development/nim-packages/nimsimd { };

    pixie = callPackage ../development/nim-packages/pixie { };

    sdl2 = callPackage ../development/nim-packages/sdl2 { };

    typography = callPackage ../development/nim-packages/typography { };

    vmath = callPackage ../development/nim-packages/vmath { };

    zippy = callPackage ../development/nim-packages/zippy { };

  })
