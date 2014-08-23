{ stdenv, pkgs, config }:

import ../generic rec {
  inherit config;

  preHook =
    ''
      export NIX_ENFORCE_PURITY=1
      export NIX_IGNORE_LD_THROUGH_GCC=1
    '' + (if stdenv.isDarwin then ''
      export NIX_ENFORCE_PURITY=
      export NIX_DONT_SET_RPATH=1
      export NIX_NO_SELF_RPATH=1
      dontFixLibtool=1
      stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
      xargsFlags=" "
      export MACOSX_DEPLOYMENT_TARGET=10.6
      export SDKROOT=$(/usr/bin/xcrun --show-sdk-path 2> /dev/null || true)
      export NIX_CFLAGS_COMPILE+=" --sysroot=/var/empty -idirafter $SDKROOT/usr/include -F$SDKROOT/System/Library/Frameworks -Wno-multichar -Wno-deprecated-declarations"
      export NIX_LDFLAGS_AFTER+=" -L$SDKROOT/usr/lib"
    '' else "");

  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativePrefix = stdenv.lib.optionalString stdenv.isSunOS "/usr";
    nativeLibc = true;
    inherit stdenv;
    binutils =
      if stdenv.isDarwin then
        import ../../build-support/native-darwin-cctools-wrapper {inherit stdenv;}
      else
        pkgs.binutils;
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
