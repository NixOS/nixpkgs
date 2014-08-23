{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre174e883b7b09da822494876d2f297736f33707a7";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/11773951/download/4/disnix-0.3pre174e883b7b09da822494876d2f297736f33707a7.tar.gz;
    sha256 = "19hdh2mrlyiq1g3z6lnnqqvripmfcdnm18jpm4anp5iarhnwh3y4";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
