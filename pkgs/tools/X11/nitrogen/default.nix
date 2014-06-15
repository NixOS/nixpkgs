{ stdenv, fetchurl, pkgconfig, glib, gtk2, gtkmm }:

let version = "1.5.2";
in
stdenv.mkDerivation rec {
  name = "nitrogen-${version}";

  src = fetchurl {
    url = "http://projects.l3ib.org/nitrogen/files/nitrogen-${version}.tar.gz";
    sha256 = "60a2437ce6a6c0ba44505fc8066c1973140d4bb48e1e5649f525c7b0b8bf9fd2";
  };

  buildInputs = [ glib gtk2 gtkmm pkgconfig ];

  NIX_LDFLAGS = "-lX11";

  patchPhase = "patchShebangs data/icon-theme-installer";

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
    maintainer = [ stdenv.lib.maintainers.auntie ];
  };
}
