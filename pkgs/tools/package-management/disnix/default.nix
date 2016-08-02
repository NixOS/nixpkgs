{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.6";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/36897417/download/4/disnix-0.6.tar.gz;
    sha256 = "1i3wxp7zn765gg0sri2jsdabkj0l7aqi8cxp46pyybdf4852d6gd";
  };
  
  buildInputs = [ pkgconfig glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
