{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre8aa12b65ced9029f7c17a494cee25e6ffc69fdea";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/6763179/download/4/disnix-0.3pre8aa12b65ced9029f7c17a494cee25e6ffc69fdea.tar.gz;
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
