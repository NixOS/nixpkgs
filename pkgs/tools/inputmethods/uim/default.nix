{ stdenv, fetchurl, intltool, pkgconfig, cmake
, ncurses, m17n_lib, m17n_db, expat
, withAnthy ? true, anthy ? null
, withGtk ? true
, withGtk2 ? withGtk, gtk2 ? null
, withGtk3 ? withGtk, gtk3 ? null
, withQt ? true
, withQt4 ? withQt, qt4 ? null
, withLibnotify ? true, libnotify ? null
, withSqlite ? true, sqlite ? null
, withNetworking ? true, curl ? null, openssl ? null
, withFFI ? true, libffi ? null

# Things that are clearly an overkill to be enabled by default
, withMisc ? false, libeb ? null
}:

with stdenv.lib;

assert withAnthy -> anthy != null;
assert withGtk2 -> gtk2 != null;
assert withGtk3 -> gtk3 != null;
assert withQt4 -> qt4 != null;
assert withLibnotify -> libnotify != null;
assert withSqlite -> sqlite != null;
assert withNetworking -> curl != null && openssl != null;
assert withFFI -> libffi != null;
assert withMisc -> libeb != null;

stdenv.mkDerivation rec {
  version = "1.8.6";
  name = "uim-${version}";

  buildInputs = [
    intltool
    pkgconfig
    ncurses
    cmake
    m17n_lib
    m17n_db
    expat
  ]
  ++ optional withAnthy anthy
  ++ optional withGtk2 gtk2
  ++ optional withGtk3 gtk3
  ++ optional withQt4 qt4
  ++ optional withLibnotify libnotify
  ++ optional withSqlite sqlite
  ++ optionals withNetworking [
    curl openssl
  ]
  ++ optional withFFI libffi
  ++ optional withMisc libeb;

  patches = [ ./data-hook.patch ];

  configureFlags = [
    "--enable-pref"
    "--with-skk"
    "--with-x"
    "--with-xft"
    "--with-expat=${expat.dev}"
  ]
  ++ optional withAnthy "--with-anthy-utf8"
  ++ optional withGtk2 "--with-gtk2"
  ++ optional withGtk3 "--with-gtk3"
  ++ optionals withQt4 [
    "--with-qt4"
    "--with-qt4-immodule"
  ]
  ++ optional withLibnotify "--enable-notify=libnotify"
  ++ optional withSqlite "--with-sqlite3"
  ++ optionals withNetworking [
    "--with-curl"
    "--with-openssl-dir=${openssl.dev}"
  ]
  ++ optional withFFI "--with-ffi"
  ++ optional withMisc "--with-eb";

  # TODO: things in `./configure --help`, but not in nixpkgs
  #--with-canna            Use Canna [default=no]
  #--with-wnn              Build with libwnn [default=no]
  #--with-mana             Build a plugin for Mana [default=yes]
  #--with-prime            Build a plugin for PRIME [default=yes]
  #--with-sj3              Use SJ3 [default=no]
  #--with-osx-dcs          Build with OS X Dictionary Services [default=no]

  dontUseCmakeConfigure = true;

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uim/uim-${version}.tar.bz2";
    sha1 = "43b9dbdead6797880e6cfc9c032ecb2d37d42777";
  };

  meta = with stdenv.lib; {
    homepage    = "https://github.com/uim/uim";
    description = "A multilingual input method framework";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes oxij ];
  };
}
