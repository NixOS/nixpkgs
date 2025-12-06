{ pkgs }:
let
  inherit (pkgs) callPackages callPackage stdenv;
  inherit (pkgs.lib)
    recurseIntoAttrs
    attrNames
    pipe
    hasPrefix
    hasSuffix
    filter
    genAttrs
    optionals
    filterAttrs
    meta
    concatMapAttrs
    optionalAttrs
    ;
  inherit (pkgs.lib.strings) toJSON;
in
{
  cc-wrapper =
    let
      pkgNames = (attrNames pkgs);
      llvmTests =
        let
          pkgSets = pipe pkgNames [
            (filter (hasPrefix "llvmPackages"))
            # Are aliases.
            (filter (n: n != "llvmPackages_latest"))
            (filter (n: n != "llvmPackages_9"))
            (filter (n: n != "llvmPackages_10"))
            (filter (n: n != "llvmPackages_11"))
            (filter (n: n != "llvmPackages_12"))
            (filter (n: n != "llvmPackages_13"))
            (filter (n: n != "llvmPackages_14"))
            (filter (n: n != "llvmPackages_15"))
            (filter (n: n != "llvmPackages_16"))
            (filter (n: n != "llvmPackages_17"))
          ];
          tests = genAttrs pkgSets (
            name:
            recurseIntoAttrs {
              clang = callPackage ./cc-wrapper { stdenv = pkgs.${name}.stdenv; };
              libcxx = callPackage ./cc-wrapper { stdenv = pkgs.${name}.libcxxStdenv; };
            }
          );
        in
        tests;
      gccTests =
        let
          pkgSets = pipe (attrNames pkgs) (
            [
              (filter (hasPrefix "gcc"))
              (filter (hasSuffix "Stdenv"))
              (filter (n: n != "gccCrossLibcStdenv"))
              (filter (n: n != "gcc49Stdenv"))
              (filter (n: n != "gcc6Stdenv"))
              (filter (n: n != "gcc7Stdenv"))
              (filter (n: n != "gcc8Stdenv"))
              (filter (n: n != "gcc9Stdenv"))
              (filter (n: n != "gcc10Stdenv"))
              (filter (n: n != "gcc11Stdenv"))
              (filter (n: n != "gcc12Stdenv"))
            ]
            ++
              optionals
                (
                  !(
                    (stdenv.buildPlatform.isLinux && stdenv.buildPlatform.isx86_64)
                    && (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64)
                  )
                )
                [
                  (filter (n: !hasSuffix "MultiStdenv" n))
                ]
          );
        in
        genAttrs pkgSets (name: callPackage ./cc-wrapper { stdenv = pkgs.${name}; });
    in
    recurseIntoAttrs {
      default = callPackage ./cc-wrapper { };

      supported = stdenv.mkDerivation {
        name = "cc-wrapper-supported";
        builtGCC =
          let
            sets = pipe gccTests [
              (filterAttrs (_: v: meta.availableOn stdenv.hostPlatform v.stdenv.cc))
              # Broken
              (filterAttrs (n: _: n != "gccMultiStdenv"))
            ];
          in
          toJSON sets;

        builtLLVM =
          let
            sets = pipe llvmTests [
              (filterAttrs (_: v: meta.availableOn stdenv.hostPlatform v.clang.stdenv.cc))
              (filterAttrs (_: v: meta.availableOn stdenv.hostPlatform v.libcxx.stdenv.cc))
            ];
          in
          toJSON sets;
        buildCommand = ''
          touch $out
        '';
      };

      llvmTests = recurseIntoAttrs llvmTests;
      gccTests = recurseIntoAttrs gccTests;
    };

  devShellTools = callPackage ../build-support/dev-shell-tools/tests { };

  stdenv-inputs = callPackage ./stdenv-inputs { };
  stdenv = recurseIntoAttrs (callPackage ./stdenv { });

  hardeningFlags = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix { });
  hardeningFlags-gcc = recurseIntoAttrs (
    callPackage ./cc-wrapper/hardening.nix {
      stdenv = pkgs.gccStdenv;
    }
  );
  hardeningFlags-clang = recurseIntoAttrs (
    callPackage ./cc-wrapper/hardening.nix {
      stdenv = pkgs.llvmPackages.stdenv;
    }
  );

  config = callPackage ./config.nix { };

  top-level = callPackage ./top-level { };

  haskell = callPackage ./haskell { };

  hooks = recurseIntoAttrs (callPackage ./hooks { });

  cc-multilib-gcc = callPackage ./cc-wrapper/multilib.nix { stdenv = pkgs.gccMultiStdenv; };
  cc-multilib-clang = callPackage ./cc-wrapper/multilib.nix { stdenv = pkgs.clangMultiStdenv; };

  compress-drv = callPackage ../build-support/compress-drv/test.nix { };

  fetchurl = recurseIntoAttrs (callPackages ../build-support/fetchurl/tests.nix { });
  fetchtorrent = recurseIntoAttrs (callPackages ../build-support/fetchtorrent/tests.nix { });
  fetchpatch = recurseIntoAttrs (callPackages ../build-support/fetchpatch/tests.nix { });
  fetchpatch2 = recurseIntoAttrs (
    callPackages ../build-support/fetchpatch/tests.nix { fetchpatch = pkgs.fetchpatch2; }
  );
  fetchDebianPatch = recurseIntoAttrs (callPackages ../build-support/fetchdebianpatch/tests.nix { });
  fetchzip = recurseIntoAttrs (callPackages ../build-support/fetchzip/tests.nix { });
  fetchgit = recurseIntoAttrs (callPackages ../build-support/fetchgit/tests.nix { });
  fetchNextcloudApp = recurseIntoAttrs (
    callPackages ../build-support/fetchnextcloudapp/tests.nix { }
  );
  fetchFromBitbucket = recurseIntoAttrs (callPackages ../build-support/fetchbitbucket/tests.nix { });
  fetchFromGitHub = recurseIntoAttrs (callPackages ../build-support/fetchgithub/tests.nix { });
  fetchFirefoxAddon = recurseIntoAttrs (
    callPackages ../build-support/fetchfirefoxaddon/tests.nix { }
  );
  fetchPypiLegacy = recurseIntoAttrs (callPackages ../build-support/fetchpypilegacy/tests.nix { });

  install-shell-files = recurseIntoAttrs (callPackage ./install-shell-files { });

  checkpointBuildTools = callPackage ./checkpointBuild { };

  kernel-config = callPackage ./kernel.nix { };

  ld-library-path = callPackage ./ld-library-path { };

  cross = recurseIntoAttrs (callPackage ./cross { });

  php = recurseIntoAttrs (callPackages ./php { });

  go = recurseIntoAttrs (callPackage ../build-support/go/tests.nix { });

  pkg-config = recurseIntoAttrs (callPackage ../top-level/pkg-config/tests.nix { });

  buildRustCrate = recurseIntoAttrs (callPackage ../build-support/rust/build-rust-crate/test { });
  importCargoLock = recurseIntoAttrs (callPackage ../build-support/rust/test/import-cargo-lock { });

  vim = callPackage ./vim { };

  nixos-functions = callPackage ./nixos-functions { };

  nixosOptionsDoc = recurseIntoAttrs (callPackage ../../nixos/lib/make-options-doc/tests.nix { });

  overriding = callPackage ./overriding.nix { };

  texlive = recurseIntoAttrs (callPackage ./texlive { });

  cuda = callPackage ./cuda { };

  trivial-builders = callPackage ../build-support/trivial-builders/test/default.nix { };

  writers = callPackage ../build-support/writers/test.nix { };

  testers = callPackage ../build-support/testers/test/default.nix { };

  dhall = callPackage ./dhall { };

  cue-validation = callPackage ./cue { };

  coq = callPackage ./coq { };

  dotnet = recurseIntoAttrs (callPackages ./dotnet { });

  makeHardcodeGsettingsPatch = recurseIntoAttrs (callPackage ./make-hardcode-gsettings-patch { });

  makeWrapper = callPackage ./make-wrapper { };
  makeBinaryWrapper = callPackage ./make-binary-wrapper {
    makeBinaryWrapper = pkgs.makeBinaryWrapper.override {
      # Enable sanitizers in the tests only, to avoid the performance cost in regular usage.
      # The sanitizers cause errors on aarch64-darwin, see https://github.com/NixOS/nixpkgs/pull/150079#issuecomment-994132734
      sanitizers =
        optionals (!(pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64))
          [
            "undefined"
            "address"
          ];
    };
  };

  pkgs-lib = recurseIntoAttrs (import ../pkgs-lib/tests { inherit pkgs; });

  buildFHSEnv = recurseIntoAttrs (callPackages ./buildFHSEnv { });

  auto-patchelf-hook = callPackage ./auto-patchelf-hook { };

  check-binary-arch-hook = callPackage ./check-binary-arch-hook { };

  # Accumulate all passthru.tests from arrayUtilities into a single attribute set.
  arrayUtilities = recurseIntoAttrs (
    concatMapAttrs (
      name: value:
      optionalAttrs (value ? passthru.tests) {
        ${name} = value.passthru.tests;
      }
    ) pkgs.arrayUtilities
  );

  srcOnly = callPackage ../build-support/src-only/tests.nix { };

  systemd = callPackage ./systemd { };

  replaceVars = recurseIntoAttrs (callPackage ./replace-vars { });

  substitute = recurseIntoAttrs (callPackage ./substitute { });

  build-environment-info = callPackage ./build-environment-info { };

  rust-hooks = recurseIntoAttrs (callPackages ../build-support/rust/hooks/test { });
}
