{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre8aa12b65ced9029f7c17a494cee25e6ffc69fdea";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/6763179/download/4/disnix-0.3pre8aa12b65ced9029f7c17a494cee25e6ffc69fdea.tar.gz;
    sha256 = "0zmsaz1kvc7dl1igh6z74jxy3w5p2zbfm9jsczdjdh3947fkni4p";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
