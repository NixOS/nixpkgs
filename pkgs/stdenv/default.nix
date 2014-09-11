# This file defines the various standard build environments.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.

{ system, allPackages ? import ../.., platform, config }:


rec {


  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stdenvNative = (import ./native {
    inherit system allPackages config;
  }).stdenv;

  stdenvNativePkgs = allPackages {
    bootStdenv = stdenvNative;
    noSysDirs = false;
  };


  # The Nix build environment.
  stdenvNix = import ./nix {
    inherit config;
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
  };

  stdenvDarwin = import ./darwin {
    inherit config;
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
  };

  stdenvDarwinNaked = import ./darwin {
    inherit config;
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
    haveLibCxx = false;
  };

  stdenvDarwin33 = import ./darwin {
    inherit config;
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
    useClang33 = true;
  };


  # Linux standard environment.
  stdenvLinux = (import ./linux { inherit system allPackages platform config;}).stdenvLinux;


  # Select the appropriate stdenv for the platform `system'.
  stdenv =
    if system == "i686-linux" then stdenvLinux else
    if system == "x86_64-linux" then stdenvLinux else
    if system == "armv5tel-linux" then stdenvLinux else
    if system == "armv6l-linux" then stdenvLinux else
    if system == "armv7l-linux" then stdenvLinux else
    if system == "mips64el-linux" then stdenvLinux else
    if system == "powerpc-linux" then /* stdenvLinux */ stdenvNative else
    if system == "x86_64-darwin" then stdenvDarwin else
    if system == "x86_64-solaris" then stdenvNix else
    stdenvNative;
}
