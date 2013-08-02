{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre57b56b6b9d43b48ce72e4e47f6acfdb3b1cbe3ef";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/5576475/download/4/disnix-0.3pre57b56b6b9d43b48ce72e4e47f6acfdb3b1cbe3ef.tar.gz;
    sha256 = "18sxs4c3a1sr2sldd6p7rmxg6541v1hsl987vzc7ij8mwkcnm1r0";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
