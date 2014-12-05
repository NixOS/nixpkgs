{ stdenv, pkgs, config, lib }:

import ../generic rec {
  inherit config;

  preHook =
    ''
      export NIX_ENFORCE_PURITY=1
      export NIX_IGNORE_LD_THROUGH_GCC=1
    '';

  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativePrefix = stdenv.lib.optionalString stdenv.isSunOS "/usr";
    nativeLibc = true;
    inherit stdenv;
    binutils = pkgs.binutils;
    gcc = pkgs.gcc.gcc;
    coreutils = pkgs.coreutils;
    shell = pkgs.bash + "/bin/sh";
  };

  shell = pkgs.bash + "/bin/sh";

  fetchurlBoot = stdenv.fetchurlBoot;

  overrides = pkgs_: {
    inherit gcc;
    inherit (gcc) binutils;
    inherit (pkgs)
      gzip bzip2 xz bash coreutils diffutils findutils gawk
      gnumake gnused gnutar gnugrep gnupatch perl;
  };
}
