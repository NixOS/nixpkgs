{ lib, stdenv, fetchurl, ncurses, libtool, gettext, autoconf, automake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "procps-${version}";
  version = "3.3.14";

  src = fetchurl {
    url = "https://gitlab.com/procps-ng/procps/-/archive/v${version}/procps-v${version}.tar.bz2";
    sha256 = "0igvsl3s7m5ygxgypzksk4cp2wkvv3lk49s7i9m5wbimyakmr0vf";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ libtool gettext autoconf automake pkgconfig ];

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
