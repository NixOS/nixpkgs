{ lib, stdenv, fetchFromGitLab, fetchpatch, ncurses, libtool, gettext, autoconf, automake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "procps-${version}";
  version = "3.3.13";

  src = fetchFromGitLab {
    owner ="procps-ng";
    repo = "procps";
    rev = "v${version}";
    sha256 = "0r3h9adhqi5fi62lx65z839fww35lfh2isnknhkaw71xndjpzr0q";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ libtool gettext autoconf automake pkgconfig ];

  # https://gitlab.com/procps-ng/procps/issues/88
  # Patches needed for musl and glibc 2.28
  patches = [
    (fetchpatch {
      url = "https://gitlab.com/procps-ng/procps/uploads/f91ff094be1e4638aeffb67bdbb751ba/numa.h.diff";
      sha256 = "16r537d2wfrvbv6dg9vyfck8n31xa58903mnssw1s4kb5ap83yd5";
      extraPrefix = "";
    })
    (fetchpatch {
      url = "https://gitlab.com/procps-ng/procps/uploads/6a7bdea4d82ba781451316fda74192ae/libio_detection.diff";
      sha256 = "0qp0j60kiycjsv213ih10imjirmxz8zja3rk9fq5lr5xf7k2lr3p";
    })
  ];

  # autoreconfHook doesn't quite get, what procps-ng buildprocss does
  # with po/Makefile.in.in and stuff.
  preConfigure = ''
    ./autogen.sh
  '';

  makeFlags = "usrbin_execdir=$(out)/bin";

  enableParallelBuilding = true;

  # Too red
  configureFlags = [ "--disable-modern-top" ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform)
    [ "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes" ];

  meta = {
    homepage = https://gitlab.com/procps-ng/procps;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 10; # less than coreutils, which also provides "kill" and "uptime"
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.cygwin;
    maintainers = [ lib.maintainers.typetetris ];
  };
}
