# This file defines the various standard build environments.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.

{system, allPackages}: rec {


  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stdenvNative = (import ../stdenv/native) {system = system;};

  stdenvNativePkgs = allPackages {system = system; stdenv = stdenvNative;};


  # The Nix build environment.
  stdenvNix = (import ../stdenv/nix) {
    bootStdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
  };

  stdenvNixPkgs = allPackages {system = system; stdenv = stdenvNix;};


  # The Linux build environment is a fully bootstrapped Nix
  # environment, that is, it should contain no external references.

  # 1) Build glibc in the native build environment.  The result is
  #    pure (I promise!).
  stdenvLinuxGlibc = stdenvNativePkgs.glibc;

  # 2) Construct a stdenv consisting of the native build environment,
  #    plus the pure glibc.
  stdenvLinuxBoot1 = (import ../stdenv/nix-linux/boot.nix) {
    system = system;
    glibc = stdenvLinuxGlibc;
  };

  # 3) Now we can build packages that will have the Nix glibc.
  stdenvLinuxBoot1Pkgs = allPackages {system = system; stdenv = stdenvLinuxBoot1;};

  # 4) However, since these packages are built by an native C compiler
  #    and linker, they may well pick up impure references (e.g., bash
  #    might end up linking against /lib/libncurses).  So repeat, but
  #    now use the Nix-built tools from step 2/3.
  stdenvLinuxBoot2 = (import ../stdenv/nix-linux) {
    bootStdenv = stdenvLinuxBoot1;
    pkgs = stdenvLinuxBoot1Pkgs;
    glibc = stdenvLinuxGlibc;
  };

  # 5) These packages should be pure.
  stdenvLinuxBoot2Pkgs = allPackages {system = system; stdenv = stdenvLinuxBoot2;};

  # 6) So finally we can construct the Nix build environment.
  stdenvLinux = (import ../stdenv/nix-linux) {
    bootStdenv = stdenvLinuxBoot2;
    pkgs = stdenvLinuxBoot2Pkgs;
    glibc = stdenvLinuxGlibc;
  };

  # 7) And we can build all packages against that, but we don't
  #    rebuild stuff from step 6.
  stdenvLinuxPkgs =
    allPackages {system = system; stdenv = stdenvLinux;} //
    {inherit (stdenvLinuxBoot2Pkgs)
      gzip bzip2 bash binutils coreutils diffutils findutils gawk gcc
      gnumake gnused gnutar gnugrep wget;
    } //
    {glibc = stdenvLinuxGlibc;};
}
