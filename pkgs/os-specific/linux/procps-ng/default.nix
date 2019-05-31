{ lib, stdenv, fetchurl, ncurses, pkgconfig

# `ps` with systemd support is able to properly report different
# attributes like unit name, so we want to have it on linux.
, withSystemd ? stdenv.isLinux
, systemd ? null

# procps is mostly Linux-only. Most commands require a running Linux
# system (or very similar like that found in Cygwin). The one
# exception is ‘watch’ which is portable enough to run on pretty much
# any UNIX-compatible system.
, watchOnly ? !(stdenv.isLinux || stdenv.isCygwin)
}:

stdenv.mkDerivation rec {
  name = "procps-${version}";
  version = "3.3.15";

  # The project's releases are on SF, but git repo on gitlab.
  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/procps-ng-${version}.tar.xz";
    sha256 = "0r84kwa5fl0sjdashcn4vh7hgfm7ahdcysig3mcjvpmkzi7p9g8h";
  };

  buildInputs = [ ncurses ]
    ++ lib.optional withSystemd systemd;
  nativeBuildInputs = [ pkgconfig ];

  makeFlags = [ "usrbin_execdir=$(out)/bin" ]
    ++ lib.optionals watchOnly [ "watch" "PKG_LDFLAGS="];

  enableParallelBuilding = true;

  # Too red
  configureFlags = [ "--disable-modern-top" ]
    ++ lib.optional withSystemd "--with-systemd"
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform)
    [ "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes" ];

  installPhase = if watchOnly then ''
    install -m 0755 -D watch $out/bin/watch
    install -m 0644 -D watch.1 $out/share/man/man1/watch.1
  '' else null;

  meta = {
    homepage = https://gitlab.com/procps-ng/procps;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 11; # less than coreutils, which also provides "kill" and "uptime"
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.typetetris ];
  };
}
