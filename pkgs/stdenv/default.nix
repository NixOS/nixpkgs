# This file defines the various standard build environments.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.

{system, allPackages}:

rec {

  gccWrapper = import ../build-support/gcc-wrapper;
  genericStdenv = import ./generic;


  # Trivial environment used for building other environments.
  stdenvInitial = (import ./initial) {
    name = "stdenv-initial";
    inherit system;
  };


  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stdenvNative = (import ./native) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvNativePkgs = allPackages {
    bootStdenv = stdenvNative;
    noSysDirs = false;
  };


  # The Nix build environment.
  stdenvNix = (import ./nix) {
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
    inherit genericStdenv gccWrapper;
  };

  stdenvNixPkgs = allPackages {
    bootStdenv = stdenvNix;
    noSysDirs = false;
  };


  # Linux standard environment.
  inherit (import ./linux {inherit allPackages;})
    stdenvLinux stdenvLinuxPkgs;

    
  # Darwin (Mac OS X) standard environment.  Very simple for now
  # (essentially it's just the native environment).
  stdenvDarwin = (import ./darwin) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvDarwinPkgs = allPackages {
    bootStdenv = stdenvDarwin;
    noSysDirs = false;
  };


  # FreeBSD standard environment.  Right now this is more or less the
  # same as the native environemnt.  Eventually we'll want a pure
  # environment similar to stdenvLinux.
  stdenvFreeBSD = (import ./freebsd) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  stdenvFreeBSDPkgs = allPackages {
    bootStdenv = stdenvFreeBSD;
    noSysDirs = false;
  };


  # Select the appropriate stdenv for the platform `system'.
  stdenv =
    if system == "i686-linux" then stdenvLinux
    else if system == "i686-freebsd" then stdenvFreeBSD
    else if system == "powerpc-darwin" then stdenvDarwin
    else stdenvNative;
}
