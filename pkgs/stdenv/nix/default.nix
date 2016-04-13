{ stdenv, pkgs, config, lib }:

import ../generic rec {
  inherit config;

  preHook =
    ''
      export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
      export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
      export NIX_IGNORE_LD_THROUGH_GCC=1
    '';

  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  cc = import ../../build-support/cc-wrapper {
    nativeTools = false;
    nativePrefix = stdenv.lib.optionalString stdenv.isSunOS "/usr";
    nativeLibc = true;
    inherit stdenv;
    inherit (pkgs) binutils coreutils gnugrep;
    cc = pkgs.gcc.cc;
    isGNU = true;
    shell = pkgs.bash + "/bin/sh";
  };

  shell = pkgs.bash + "/bin/sh";

  fetchurlBoot = stdenv.fetchurlBoot;

  overrides = pkgs_: {
    inherit cc;
    inherit (cc) binutils;
    inherit (pkgs)
      gzip bzip2 xz bash coreutils diffutils findutils gawk
      gnumake gnused gnutar gnugrep gnupatch perl;
  };
}
