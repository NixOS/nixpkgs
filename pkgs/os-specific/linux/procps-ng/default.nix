{ lib, stdenv, fetchFromGitLab, ncurses, libtool, gettext, autoconf, automake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "procps-${version}";
  version = "3.3.14";

  src = fetchFromGitLab {
    owner ="procps-ng";
    repo = "procps";
    rev = "v${version}";
    sha256 = "0l2xfm3vr8qpzvdnkcvmfj1rdw6lxx840zw9vp0z9f008y5fc31g";
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
