# This file defines the various standard build environments.
#
# On Linux systems, the standard build environment consists of
# Nix-built instances glibc and the `standard' Unix tools, i.e., the
# Posix utilities, the GNU C compiler, and so on.  On other systems,
# we use the native C library.


# stdenvType exists to support multiple kinds of stdenvs on the same
# system, e.g., cygwin and mingw builds on i686-cygwin.  Most people
# can ignore it.

{system, stdenvType ? system, allPackages}:

assert system != "i686-cygwin" -> system == stdenvType;


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
  stdenvNix = (import ./nix) (rec {
    stdenv = if system == "i686-darwin" then stdenvPowerpcDarwin else stdenvNative; # !!! hack
    pkgs = allPackages {
      inherit system;
      bootStdenv = removeAttrs stdenv ["gcc"]; # Hack
      noSysDirs = false;
    };
  });


  # Linux standard environment.
  stdenvLinux = (import ./linux {inherit system allPackages;}).stdenvLinux;

    
  # powerpc-darwin (Mac OS X) standard environment.  Very simple for now
  # (essentially it's just the native environment).
  stdenvPowerpcDarwin = (import ./powerpc-darwin) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };


  # FreeBSD standard environment.  Right now this is more or less the
  # same as the native environemnt.  Eventually we'll want a pure
  # environment similar to stdenvLinux.
  stdenvFreeBSD = (import ./freebsd) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };


  # Cygwin standard environment.
  stdenvCygwin = (import ./cygwin) {
    stdenv = stdenvInitial;
    inherit genericStdenv gccWrapper;
  };

  
  # MinGW/MSYS standard environment.
  stdenvMinGW = (import ./mingw) {
    inherit system;
  };

  
  # Select the appropriate stdenv for the platform `system'.
  stdenv =
    if stdenvType == "i686-linux" then stdenvLinux else
    if stdenvType == "x86_64-linux" then stdenvLinux else
    if stdenvType == "powerpc-linux" then stdenvLinux else
    if stdenvType == "i686-freebsd" then stdenvFreeBSD else
    if stdenvType == "i686-cygwin" then stdenvCygwin else
    if stdenvType == "i686-mingw" then stdenvMinGW else
    if stdenvType == "powerpc-darwin" then stdenvPowerpcDarwin else
    if stdenvType == "i686-darwin" then stdenvNix else
    stdenvNative;
}
