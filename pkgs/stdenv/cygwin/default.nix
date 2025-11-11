{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
}:

assert crossSystem == localSystem;
let
  bootStages = import ../. {
    inherit lib overlays;

    localSystem = lib.systems.elaborate "x86_64-linux";

    crossSystem = localSystem;
    crossOverlays = [ ];

    # Ignore custom stdenvs when cross compiling for compatibility
    # Use replaceCrossStdenv instead.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in
bootStages
++ [

  (
    prevStage:
    let
      name = "cygwin";

      initialPath =
        ((import ../generic/common-path.nix) { pkgs = prevStage; })
        # needed for cygwin1.dll
        ++ [ "/" ];

      shell = "${prevStage.bashNonInteractive}/bin/bash";

      stdenvNoCC = import ../generic {
        inherit
          config
          initialPath
          shell
          fetchurlBoot
          ;
        name = "stdenvNoCC-${name}";
        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        cc = null;
      };

      fetchurlBoot = import ../../build-support/fetchurl {
        inherit lib stdenvNoCC;
        inherit (prevStage) curl;
        inherit (config) rewriteURL hashedMirrors;
      };

      gcc = (
        prevStage.gccFun {
          noSysDirs = true;
          majorMinorVersion = toString prevStage.default-gcc-version;
          targetPackages.stdenv.cc.bintools = prevStage.stdenv.cc.bintools;
        }
      );

    in
    {
      inherit config overlays stdenvNoCC;
      stdenv = import ../generic rec {
        name = "stdenv-cygwin";

        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        inherit
          config
          initialPath
          fetchurlBoot
          shell
          ;

        cc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
          inherit lib stdenvNoCC;
          name = "${name}-cc";
          cc = gcc;
          isGNU = true;
          libc = prevStage.cygwin.newlib-cygwin;
          inherit (prevStage) gnugrep coreutils expand-response-params;
          nativeTools = false;
          nativeLibc = false;
          propagateDoc = false;
          runtimeShell = shell;
          bintools = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
            inherit lib stdenvNoCC;
            name = "${name}-bintools";
            bintools = prevStage.bintools-unwrapped;
            libc = prevStage.cygwin.newlib-cygwin;
            inherit (prevStage) gnugrep coreutils expand-response-params;
            nativeTools = false;
            nativeLibc = false;
            propagateDoc = false;
            runtimeShell = shell;
          };
        };

        overrides = self: super: {
          fetchurl = lib.makeOverridable fetchurlBoot;
          __bootstrapPackages =
            (import ../generic/common-path.nix) { pkgs = prevStage; }
            ++ [
              gcc
              gcc.lib
            ]
            ++ (with prevStage; [
              curl
              curl.dev
              cygwin.newlib-cygwin
              cygwin.newlib-cygwin.bin
              cygwin.newlib-cygwin.dev
              cygwin.w32api
              cygwin.w32api.dev
              bintools-unwrapped
              gnugrep
              coreutils
              expand-response-params
            ]);
        };
      };
    }
  )
]
