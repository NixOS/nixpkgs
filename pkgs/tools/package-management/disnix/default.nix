{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre8aa12b65ced9029f7c17a494cee25e6ffc69fdea";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/9876935/download/4/disnix-0.3pre15e93a364ad9439d8336e659921600d48252045d.tar.gz;
    sha256 = "1kgc6cacpp3ly7c62ah6pdprdl1bab08b4ir4dcrrm44x6fa1k63";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
