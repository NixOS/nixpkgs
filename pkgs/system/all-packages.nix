# This file evaluates to a function that, when supplied with a system
# identifier, returns the set of all packages provided by the Nix
# Package Collection.  It does this by supplying
# `all-packages-generic.nix' with a standard build environment.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.

{system}: let {
  allPackages = import ./all-packages-generic.nix;

  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stdenvNative = (import ../stdenv/native) {system = system};
  stdenvNativePkgs = allPackages {system = system; stdenv = stdenvNative};

  # The Nix build environment.
  stdenvNix = (import ../stdenv/nix) {
    bootStdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
  };
  stdenvNixPkgs = allPackages {system = system; stdenv = stdenvNix};

  # The Linux build environment consists of the Nix build environment
  # built against the GNU C Library.
  stdenvLinuxGlibc = stdenvNativePkgs.glibc;
  stdenvLinuxBoot = (import ../stdenv/nix-linux/boot.nix) {
    system = system;
    glibc = stdenvLinuxGlibc;
  };
  stdenvLinuxBootPkgs = allPackages {system = system; stdenv = stdenvLinuxBoot};

  stdenvLinux = (import ../stdenv/nix-linux) {
    bootStdenv = stdenvLinuxBoot;
    pkgs = stdenvLinuxBootPkgs;
    glibc = stdenvLinuxGlibc;
  };
  stdenvLinuxPkgs = allPackages {system = system; stdenv = stdenvLinux};

  # Select the right instantiation.
  body =
    if system == "i686-linux"
    then stdenvLinuxPkgs
    else stdenvNixPkgs;
}
