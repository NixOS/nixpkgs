# This file defines the various standard build environments.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.

{system, allPackages}: rec {

  gccWrapper = import ../build-support/gcc-wrapper;
  genericStdenv = import ../stdenv/generic;


  # Trivial environment used for building other environments.
  stdenvInitial = (import ../stdenv/initial) {
    name = "stdenv-initial";
    inherit system;
  };


  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stdenvNative = (import ../stdenv/native) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvNativePkgs = allPackages {
    stdenv = stdenvNative;
    bootCurl = null;
    noSysDirs = false;
  };


  # The Nix build environment.
  stdenvNix = (import ../stdenv/nix) {
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
    inherit genericStdenv gccWrapper;
  };

  stdenvNixPkgs = allPackages {
    stdenv = stdenvNix;
    bootCurl = stdenvNativePkgs.curl;
    noSysDirs = false;
  };


  # Linux standard environment.
  inherit (import ../stdenv/linux {inherit allPackages;})
    stdenvLinux stdenvLinuxPkgs;

    
  # Darwin (Mac OS X) standard environment.  Very simple for now
  # (essentially it's just the native environment).
  stdenvDarwin = (import ../stdenv/darwin) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvDarwinPkgs = allPackages {
    stdenv = stdenvDarwin;
    bootCurl = null;
    noSysDirs = false;
  };


  # FreeBSD standard environment.  Right now this is more or less the
  # same as the native environemnt.  Eventually we'll want a pure
  # environment similar to stdenvLinux.
  stdenvFreeBSD = (import ../stdenv/freebsd) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvFreeBSDPkgs = allPackages {
    stdenv = stdenvFreeBSD;
    bootCurl = null;
    noSysDirs = false;
  };


  stdenvTestPkgs = allPackages {
    stdenv = (import ../stdenv/nix-linux-static).stdenvInitial;
    bootCurl = (import ../stdenv/nix-linux-static).curl;
    noSysDirs = true;
  };
}
