{ lib
, crossSystem, localSystem, config, overlays
, bootStages
, ...
}:

assert crossSystem == localSystem;

bootStages ++ [
  (prevStage: {
    inherit config overlays;

    stdenv = import ../generic rec {
      inherit config;

      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;

      preHook = ''
        export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
        export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        export NIX_IGNORE_LD_THROUGH_GCC=1
      '';

      initialPath = (import ../generic/common-path.nix) { pkgs = prevStage; };

      cc = import ../../build-support/cc-wrapper {
        inherit lib;
        nativeTools = false;
        nativePrefix = lib.optionalString hostPlatform.isSunOS "/usr";
        nativeLibc = true;
        inherit (prevStage) stdenvNoCC binutils coreutils gnugrep;
        cc = prevStage.gcc.cc;
        isGNU = true;
        shell = prevStage.bash + "/bin/sh";
      };

      shell = prevStage.bash + "/bin/sh";

      fetchurlBoot = prevStage.stdenv.fetchurlBoot;

      overrides = self: super: {
        inherit cc;
        inherit (cc) binutils;
        inherit (prevStage)
          gzip bzip2 xz bash coreutils diffutils findutils gawk
          gnumake gnused gnutar gnugrep gnupatch perl;
      };
    };
  })
]
