{ stdenv, pkgs, config
, haveLibCxx ? true
, useClang33 ? true }:

import ../generic rec {
  inherit config;

  preHook =
    ''
      export NIX_ENFORCE_PURITY=
      export NIX_IGNORE_LD_THROUGH_GCC=1
      export NIX_DONT_SET_RPATH=1
      export NIX_NO_SELF_RPATH=1
      ${import ./prehook.nix}
    '';

  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativeLibc = true;
    inherit stdenv;
    extraPackages = stdenv.lib.optional haveLibCxx pkgs.libcxx;
    binutils = import ../../build-support/native-darwin-cctools-wrapper {inherit stdenv;};
    gcc = if useClang33 then pkgs.clang_33.gcc else pkgs.clang.gcc;
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
      gnumake gnused gnutar gnugrep gnupatch perl libcxx libcxxabi;
  };
}
