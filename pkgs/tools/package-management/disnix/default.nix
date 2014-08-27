{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixStable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre24d959b3b37ce285971810245643a7f18cb85fcc";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/13462853/download/4/disnix-0.3pre24d959b3b37ce285971810245643a7f18cb85fcc.tar.gz;
    sha256 = "408707ce29497dae6c960af0e4874659a7da6a5fd49629ebe0d8c167f0dbf19a";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixStable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
