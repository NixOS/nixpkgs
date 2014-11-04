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
      dontFixLibtool=1
      stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
      xargsFlags=" "
      export MACOSX_DEPLOYMENT_TARGET=10.9
      export SDKROOT=$(/usr/bin/xcrun --sdk macosx10.9 --show-sdk-path 2> /dev/null || true)
      export NIX_CFLAGS_COMPILE+=" --sysroot=/var/empty -idirafter $SDKROOT/usr/include -F$SDKROOT/System/Library/Frameworks -Wno-multichar -Wno-deprecated-declarations"
      export NIX_LDFLAGS_AFTER+=" -L$SDKROOT/usr/lib"
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
