{ stdenv, fetchurl, pkgconfig, glib, gtkmm2 }:

let version = "1.6.0";
in
stdenv.mkDerivation rec {
  name = "nitrogen-${version}";

  src = fetchurl {
    url = "http://projects.l3ib.org/nitrogen/files/${name}.tar.gz";
    sha256 = "1pil2qa3v7x56zh9xvba8v96abnf9qgglbsdlrlv0kfjlhzl4jhr";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib gtkmm2 ];

  NIX_CXXFLAGS_COMPILE = "-std=c++11";

  patchPhase = ''
    substituteInPlace data/Makefile.in --replace /usr/share $out/share
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
