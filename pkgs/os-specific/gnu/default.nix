# Packages that make up the GNU/Hurd operating system (aka. GNU).

args@{ fetchgit, stdenv, autoconf, automake, automake111x, libtool
, texinfo, glibcCross, hurdPartedCross, libuuid, samba_light
, gccCrossStageStatic, gccCrossStageFinal
, forceBuildDrv, forceSystem, callPackage, platform, config, crossSystem
, __overrides ? {} }:

with args;

rec {
  # Allow callers to override elements of this attribute set.
  inherit __overrides;

  hurdCross = forceBuildDrv(import ./hurd {
    inherit fetchgit stdenv autoconf libtool texinfo machHeaders
      mig glibcCross hurdPartedCross;
    libuuid = libuuid.hostDrv;
    automake = automake111x;
    headersOnly = false;
    cross = assert crossSystem != null; crossSystem;
    gccCross = gccCrossStageFinal;
  });

  hurdCrossIntermediate = forceBuildDrv(import ./hurd {
    inherit fetchgit stdenv autoconf libtool texinfo machHeaders
      mig glibcCross;
    automake = automake111x;
    headersOnly = false;
    cross = assert crossSystem != null; crossSystem;

    # The "final" GCC needs glibc and the Hurd libraries (libpthread in
    # particular) so we first need an intermediate Hurd built with the
    # intermediate GCC.
    gccCross = gccCrossStageStatic;

    # This intermediate Hurd is only needed to build libpthread, which needs
    # libihash, and to build Parted, which needs libstore and
    # libshouldbeinlibc.
    buildTarget = "libihash libstore libshouldbeinlibc";
    installTarget = "libihash-install libstore-install libshouldbeinlibc-install";
  });

  hurdHeaders = callPackage ./hurd {
    automake = automake111x;
    headersOnly = true;
    gccCross = null;
    glibcCross = null;
    libuuid = null;
    hurdPartedCross = null;
  };

  libpthreadHeaders = callPackage ./libpthread {
    headersOnly = true;
    hurd = null;
  };

  libpthreadCross = forceBuildDrv(import ./libpthread {
    inherit fetchgit stdenv autoconf automake libtool
      machHeaders hurdHeaders glibcCross;
    hurd = hurdCrossIntermediate;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  });

  # In theory GNU Mach doesn't have to be cross-compiled.  However, since it
  # has to be built for i586 (it doesn't work on x86_64), one needs a cross
  # compiler for that host.
  mach = callPackage ./mach {
    automake = automake111x;
  };

  machHeaders = callPackage ./mach {
    automake = automake111x;
    headersOnly = true;
    mig = null;
  };

  mig = callPackage ./mig {
    # Build natively, but force use of a 32-bit environment because we're
    # targeting `i586-pc-gnu'.
    stdenv = (forceSystem "i686-linux").stdenv;
  };

  # XXX: Use this one for its `.hostDrv'.  Using the one above from
  # `x86_64-linux' leads to building a different cross-toolchain because of
  # the `forceSystem'.
  mig_raw = callPackage ./mig {};

  smbfs = callPackage ./smbfs {
    samba = samba_light;
    hurd = hurdCross;
  };

  unionfs = callPackage ./unionfs {
    hurd = hurdCross;
  };
}
