{ pkgs, callPackage }:

with pkgs;

{
  cc-wrapper = with builtins; let
    pkgNames = (attrNames pkgs);
    llvmTests = let
      pkgSets = lib.pipe pkgNames [
        (filter (lib.hasPrefix "llvmPackages"))
        (filter (n: n != "rocmPackages.llvm"))
        # Are throw aliases.
        (filter (n: n != "llvmPackages_rocm"))
        (filter (n: n != "llvmPackages_latest"))
        (filter (n: n != "llvmPackages_git"))
        (filter (n: n != "llvmPackages_6"))
        (filter (n: n != "llvmPackages_7"))
        (filter (n: n != "llvmPackages_8"))
        (filter (n: n != "llvmPackages_10"))
        (filter (n: n != "llvmPackages_11"))
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
          inherit (lib) filterAttrs;
          sets = lib.pipe gccTests ([
            (filterAttrs (_: v: lib.meta.availableOn stdenv.hostPlatform v.stdenv.cc))
            # Broken
            (filterAttrs (n: _: n != "gcc49Stdenv"))
            (filterAttrs (n: _: n != "gccMultiStdenv"))
          ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
            # fails with things like
            # ld: warning: ld: warning: object file (trunctfsf2_s.o) was built for newer macOS version (11.0) than being linked (10.5)
            # ld: warning: ld: warning: could not create compact unwind for ___fixunstfdi: register 20 saved somewhere other than in frame
            (filterAttrs (n: _: n != "gcc11Stdenv"))
          ]);
        in
        toJSON sets;

      builtLLVM =
        let
          inherit (lib) filterAttrs;
          sets = lib.pipe llvmTests ([
            (filterAttrs (_: v: lib.meta.availableOn stdenv.hostPlatform v.clang.stdenv.cc))
            (filterAttrs (_: v: lib.meta.availableOn stdenv.hostPlatform v.libcxx.stdenv.cc))

            # libcxxStdenv broken
            # fix in https://github.com/NixOS/nixpkgs/pull/216273
          ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
            (filterAttrs (n: _: n != "llvmPackages_9"))
          ]);
        in
        toJSON sets;
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
  fetchtorrent = callPackages ../build-support/fetchtorrent/tests.nix { };
  fetchpatch = callPackages ../build-support/fetchpatch/tests.nix { };
  fetchpatch2 = callPackages ../build-support/fetchpatch/tests.nix { fetchpatch = fetchpatch2; };
  fetchDebianPatch = callPackages ../build-support/fetchdebianpatch/tests.nix { };
  fetchzip = callPackages ../build-support/fetchzip/tests.nix { };
  fetchgit = callPackages ../build-support/fetchgit/tests.nix { };
  fetchFirefoxAddon = callPackages ../build-support/fetchfirefoxaddon/tests.nix { };
  fetchPypiLegacy = callPackages ../build-support/fetchpypilegacy/tests.nix { };

  install-shell-files = callPackage ./install-shell-files {};

  checkpointBuildTools = callPackage ./checkpointBuild {};

  kernel-config = callPackage ./kernel.nix {};

  ld-library-path = callPackage ./ld-library-path {};

  macOSSierraShared = callPackage ./macos-sierra-shared {};

  cross = callPackage ./cross {} // { __attrsFailEvaluation = true; };

  php = recurseIntoAttrs (callPackages ./php {});

  pkg-config = recurseIntoAttrs (callPackage ../top-level/pkg-config/tests.nix { }) // { __recurseIntoDerivationForReleaseJobs = true; };

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

  buildFHSEnv = recurseIntoAttrs (callPackages ./buildFHSEnv { });

  nixpkgs-check-by-name = throw "tests.nixpkgs-check-by-name is now specified in a separate repository: https://github.com/NixOS/nixpkgs-check-by-name";

  auto-patchelf-hook = callPackage ./auto-patchelf-hook { };

  systemd = callPackage ./systemd { };

  substitute = recurseIntoAttrs (callPackage ./substitute { });
}
