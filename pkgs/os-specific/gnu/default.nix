# Packages that make up the GNU/Hurd operating system (aka. GNU).

args@{ fetchgit, stdenv, autoconf, automake, automake111x, libtool
, texinfo, glibcCross, hurdPartedCross, libuuid, samba_light
, gccCrossStageStatic, gccCrossStageFinal
, forceBuildDrv, forceSystem, newScope, platform, config, crossSystem
, overrides ? {} }:

with args;

let
  callPackage = newScope gnu;

  gnu = {
    hurdCross = forceBuildDrv(callPackage ./hurd {
      inherit fetchgit stdenv autoconf libtool texinfo
        glibcCross hurdPartedCross;
      inherit (gnu) machHeaders mig;
      libuuid = libuuid.hostDrv;
      automake = automake111x;
      headersOnly = false;
      cross = assert crossSystem != null; crossSystem;
      gccCross = gccCrossStageFinal;
    });

    hurdCrossIntermediate = forceBuildDrv(callPackage ./hurd {
      inherit fetchgit stdenv autoconf libtool texinfo glibcCross;
      inherit (gnu) machHeaders mig;
      hurdPartedCross = null;
      libuuid = null;
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

    libpthreadCross = forceBuildDrv(callPackage ./libpthread {
      inherit fetchgit stdenv autoconf automake libtool glibcCross;
      inherit (gnu) machHeaders hurdHeaders;
      hurd = gnu.hurdCrossIntermediate;
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
      hurd = gnu.hurdCross;
    };

    unionfs = callPackage ./unionfs {
      hurd = gnu.hurdCross;
    };
  }

  # Allow callers to override elements of this attribute set.
  // overrides;

in gnu # we trust!
