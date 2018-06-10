{ stdenv, fetchurl, pkgconfig, glib, gtkmm2 }:

let version = "1.6.1";
in
stdenv.mkDerivation rec {
  name = "nitrogen-${version}";

  src = fetchurl {
    url = "http://projects.l3ib.org/nitrogen/files/${name}.tar.gz";
    sha256 = "0zc3fl1mbhq0iyndy4ysmy8vv5c7xwf54rbgamzfhfvsgdq160pl";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib gtkmm2 ];

  patchPhase = ''
    patchShebangs data/icon-theme-installer
  '';

  meta = {
    description = "A wallpaper browser and setter for X11";
    longDescription = ''
      nitrogen is a lightweight utility that can set the root background on X11.
      It operates independently of any desktop environment, and supports
      multi-head with Xinerama. Wallpapers are browsable with a convenient GUI,
      and settings are stored in a human-readable config file.
    '';
    homepage = http://projects.l3ib.org/nitrogen/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
