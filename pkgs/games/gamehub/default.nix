{ stdenv, meson, ninja, pkgconfig, fetchFromGitHub, glib, vala, ctpl
, libgee, libsoup, fcgi, pantheon, gtk3, webkitgtk, json-glib, sqlite
, xml2, polkit, gobject-introspection, libunity }:

stdenv.mkDerivation rec {
  pname = "gamehub";
  version = "0.13.1-47-dev";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = pname;
    rev = version;
    sha256 = "0yc599rjgh78cdihdagg0r2gb486x1c3vaz7yrf5v9a7fyyrlh1p";
  };

  patches = [ ./0001-Remove-post-install-script-that-hardcodes-paths.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
  ];

  buildInputs = [
    vala
    pantheon.granite
    gtk3
    #ctpl
    glib
    webkitgtk
    json-glib
    libgee
    libsoup
    sqlite
    xml2
    polkit
    #fcgi
    libunity
  ];

  meta = with stdenv.lib; {
    homepage = https://tkashkin.tk/projects/gamehub/;
    description = "Unified library for all your games, written in Vala using GTK+3";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.nyanloutre ];
  };
}
