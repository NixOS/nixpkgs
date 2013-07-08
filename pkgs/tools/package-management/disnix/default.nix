{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre106668a42f982af4180d7657b47d8316862d4d1d";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/5430218/download/4/disnix-0.3pre106668a42f982af4180d7657b47d8316862d4d1d.tar.gz;
    sha256 = "1cnrbw70gpkm9rg5a3j0kkbq0q0wrkc5hwqb614fvja20y52hld6";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
