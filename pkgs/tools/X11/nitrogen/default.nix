{ lib, stdenv, fetchurl, pkg-config, glib, gtkmm2 }:

stdenv.mkDerivation rec {
  pname = "nitrogen";
  version = "1.6.1";

  src = fetchurl {
    url = "http://projects.l3ib.org/nitrogen/files/${pname}-${version}.tar.gz";
    sha256 = "0zc3fl1mbhq0iyndy4ysmy8vv5c7xwf54rbgamzfhfvsgdq160pl";
  };

  nativeBuildInputs = [ pkg-config ];

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
    homepage = "https://github.com/l3ib/nitrogen";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.auntie ];
    mainProgram = "nitrogen";
  };
}
