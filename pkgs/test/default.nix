{ pkgs, callPackage }:

with pkgs;

{
  cc-wrapper = with builtins; let
    pkgNames = (attrNames pkgs);
    llvmTests = let
      pkgSets = lib.pipe pkgNames [
        (filter (lib.hasPrefix "llvmPackages"))
        (filter (n: n != "llvmPackages_rocm"))
        (filter (n: n != "llvmPackages_latest"))
        (filter (n: n != "llvmPackages_git"))
      ];
      tests = lib.genAttrs pkgSets (name: recurseIntoAttrs {
        clang = callPackage ./cc-wrapper { stdenv = pkgs.${name}.stdenv; };
        libcxx = callPackage ./cc-wrapper { stdenv = pkgs.${name}.libcxxStdenv; };
      });
    in
      tests;
    gccTests = let
      pkgSets = lib.pipe (attrNames pkgs) ([
        (filter (lib.hasPrefix "gcc"))
        (filter (lib.hasSuffix "Stdenv"))
        (filter (n: n != "gccCrossLibcStdenv"))
      ] ++ lib.optionals (!(
        (stdenv.buildPlatform.isLinux && stdenv.buildPlatform.isx86_64) &&
        (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64)
      )) [
        (filter (n: !lib.hasSuffix "MultiStdenv" n))
      ]);
    in lib.genAttrs pkgSets (name: callPackage ./cc-wrapper { stdenv = pkgs.${name}; });
  in recurseIntoAttrs {
    default = callPackage ./cc-wrapper { };

    supported = stdenv.mkDerivation {
      name = "cc-wrapper-supported";
      builtGCC =
        let
          names = lib.pipe (attrNames gccTests) ([
            (filter (n: lib.meta.availableOn stdenv.hostPlatform pkgs.${n}.cc))
            # Broken
            (filter (n: n != "gcc49Stdenv"))
            (filter (n: n != "gccMultiStdenv"))
          ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
            # fails with things like
            # ld: warning: ld: warning: object file (trunctfsf2_s.o) was built for newer macOS version (11.0) than being linked (10.5)
            # ld: warning: ld: warning: could not create compact unwind for ___fixunstfdi: register 20 saved somewhere other than in frame
            (filter (n: n != "gcc11Stdenv"))
          ]);
        in
        toJSON (lib.genAttrs names (name: { name = pkgs.${name};  }));

      builtLLVM =
        let
          names = lib.pipe (attrNames llvmTests) ([
            (filter (n: lib.meta.availableOn stdenv.hostPlatform pkgs.${n}.stdenv.cc))
            (filter (n: lib.meta.availableOn stdenv.hostPlatform pkgs.${n}.libcxxStdenv.cc))

            # libcxxStdenv broken
            # fix in https://github.com/NixOS/nixpkgs/pull/216273
          ] ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
            # libcxx does not build for some reason on aarch64-linux
            (filter (n: n != "llvmPackages_7"))
          ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
            (filter (n: n != "llvmPackages_5"))
            (filter (n: n != "llvmPackages_6"))
            (filter (n: n != "llvmPackages_7"))
            (filter (n: n != "llvmPackages_8"))
            (filter (n: n != "llvmPackages_9"))
            (filter (n: n != "llvmPackages_10"))
          ]);
        in
        toJSON (lib.genAttrs names (name: { stdenv = pkgs.${name}.stdenv; libcxx = pkgs.${name}.libcxxStdenv;  }));
        buildCommand = ''
          touch $out
        '';
    };

    llvmTests = recurseIntoAttrs llvmTests;
    inherit gccTests;
  };

  stdenv-inputs = callPackage ./stdenv-inputs { };
  stdenv = callPackage ./stdenv { };

  hardeningFlags = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {});
  hardeningFlags-gcc = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {
    stdenv = gccStdenv;
  });
  hardeningFlags-clang = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {
    stdenv = llvmPackages.stdenv;
  });

  config = callPackage ./config.nix { };

  top-level = callPackage ./top-level { };

  haskell = callPackage ./haskell { };

  hooks = callPackage ./hooks { };

  cc-multilib-gcc = callPackage ./cc-wrapper/multilib.nix { stdenv = gccMultiStdenv; };
  cc-multilib-clang = callPackage ./cc-wrapper/multilib.nix { stdenv = clangMultiStdenv; };

  fetchurl = callPackages ../build-support/fetchurl/tests.nix { };
  fetchpatch = callPackages ../build-support/fetchpatch/tests.nix { };
  fetchpatch2 = callPackages ../build-support/fetchpatch/tests.nix { fetchpatch = fetchpatch2; };
  fetchDebianPatch = callPackages ../build-support/fetchdebianpatch/tests.nix { };
  fetchzip = callPackages ../build-support/fetchzip/tests.nix { };
  fetchgit = callPackages ../build-support/fetchgit/tests.nix { };
  fetchFirefoxAddon = callPackages ../build-support/fetchfirefoxaddon/tests.nix { };

  install-shell-files = callPackage ./install-shell-files {};

  kernel-config = callPackage ./kernel.nix {};

  ld-library-path = callPackage ./ld-library-path {};

  macOSSierraShared = callPackage ./macos-sierra-shared {};

  cross = callPackage ./cross {};

  php = recurseIntoAttrs (callPackages ./php {});

  pkg-config = recurseIntoAttrs (callPackage ../top-level/pkg-config/tests.nix { });

  buildRustCrate = callPackage ../build-support/rust/build-rust-crate/test { };
  importCargoLock = callPackage ../build-support/rust/test/import-cargo-lock { };

  vim = callPackage ./vim {};

  nixos-functions = callPackage ./nixos-functions {};

  overriding = callPackage ./overriding.nix { };

  texlive = callPackage ./texlive {};

  cuda = callPackage ./cuda { };

  trivial-builders = callPackage ../build-support/trivial-builders/test/default.nix {};

  writers = callPackage ../build-support/writers/test.nix {};

  testers = callPackage ../build-support/testers/test/default.nix {};

  dhall = callPackage ./dhall { };

  cue-validation = callPackage ./cue {};

  coq = callPackage ./coq {};

  dotnet = recurseIntoAttrs (callPackages ./dotnet { });

  makeHardcodeGsettingsPatch = callPackage ./make-hardcode-gsettings-patch { };

  makeWrapper = callPackage ./make-wrapper { };
  makeBinaryWrapper = callPackage ./make-binary-wrapper {
    makeBinaryWrapper = pkgs.makeBinaryWrapper.override {
      # Enable sanitizers in the tests only, to avoid the performance cost in regular usage.
      # The sanitizers cause errors on aarch64-darwin, see https://github.com/NixOS/nixpkgs/pull/150079#issuecomment-994132734
      sanitizers = pkgs.lib.optionals (! (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64))
        [ "undefined" "address" ];
    };
  };

  pkgs-lib = recurseIntoAttrs (import ../pkgs-lib/tests { inherit pkgs; });

  nixpkgs-check-by-name = callPackage ./nixpkgs-check-by-name { };
}
