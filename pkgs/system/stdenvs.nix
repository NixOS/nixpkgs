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


  # The Linux build environment is a fully bootstrapped Nix
  # environment, that is, it should contain no external references.

  # 1) Build glibc in the Nix build environment.  The result is
  #    pure.
  stdenvLinuxGlibc = stdenvNixPkgs.glibc;

  # 2) Construct a stdenv consisting of the Nix build environment, but
  #    with a gcc-wrapper that causes linking against the glibc from
  #    step 1.  However, since the gcc wrapper here *does* look in
  #    native system directories (e.g., `/usr/lib'), it doesn't
  #    prevent impurity in the things it builds (e.g., through
  #    `-lncurses').
  stdenvLinuxBoot1 = (import ../stdenv/nix-linux) {
    stdenv = stdenvNative;
    pkgs = stdenvNativePkgs;
    glibc = stdenvLinuxGlibc;
    inherit genericStdenv gccWrapper;
  };

  # 3) Now we can build packages that will link against the Nix
  #    glibc.  We are on thin ice here: the compiler used to build
  #    these packages doesn't prevent impurity, so e.g. bash ends up
  #    linking against `/lib/libncurses.so', but the glibc from step 1
  #    *doesn't* search in `/lib' etc.  So these programs won't work.
  stdenvLinuxBoot1Pkgs = allPackages {
    stdenv = stdenvLinuxBoot1;
    bootCurl = stdenvNativePkgs.curl;
    noSysDirs = true;
  };

  # 4) Therefore we build a new standard environment which is the same
  #    as the one in step 2, but with a gcc and binutils from step 3
  #    merged in.  Since these are pure (they don't search native
  #    system directories), things built by this stdenv should be pure.
  stdenvLinuxBoot2 = (import ../stdenv/nix-linux) {
    stdenv = stdenvLinuxBoot1;
    pkgs = stdenvNativePkgs // {
      inherit (stdenvLinuxBoot1Pkgs) gcc binutils;
    };
    glibc = stdenvLinuxGlibc;
    inherit genericStdenv gccWrapper;
  };

  # 5) So these packages should be pure.
  stdenvLinuxBoot2Pkgs = allPackages {
    stdenv = stdenvLinuxBoot2;
    bootCurl = stdenvNativePkgs.curl;
  };

  # 6) Finally we can construct the Nix build environment from the
  #    packages from step 5.
  stdenvLinux = (import ../stdenv/nix-linux) {
    stdenv = stdenvLinuxBoot2;
    pkgs = stdenvLinuxBoot2Pkgs;
    glibc = stdenvLinuxGlibc;
    inherit genericStdenv gccWrapper;
  };

  # 7) And we can build all packages against that, but we don't
  #    rebuild stuff from step 6.
  stdenvLinuxPkgs =
    allPackages {
      stdenv = stdenvLinux;
      bootCurl = stdenvLinuxBoot2Pkgs.curl;
    } //
    {inherit (stdenvLinuxBoot2Pkgs)
      gzip bzip2 bash binutils coreutils diffutils findutils gawk gcc
      gnumake gnused gnutar gnugrep curl;
    } //
    {glibc = stdenvLinuxGlibc;};

  # In summary, we build gcc (and binutils) three times:
  #   - in stdenvLinuxBoot1 (from stdenvNativePkgs); impure
  #   - in stdenvLinuxBoot2 (from stdenvLinuxBoot1Pkgs); pure
  #   - in stdenvLinux (from stdenvLinuxBoot2Pkgs); pure
  # The last one may be redundant, but its good for validation (since
  # the second one may use impure inputs).  To reduce build time, we
  # could reduce the number of bootstrap stages inside each gcc build.
  # Right now there are 3 stages, so gcc is built 9 times!

  # On the other hand, a validating build of glibc is a good idea (it
  # probably won't work right now due to --rpath madness).


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

}
