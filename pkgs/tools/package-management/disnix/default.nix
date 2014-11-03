{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3prea0484a2c19d1947c21f11b4fc7c3f6049bd11efa";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/14710186/download/4/disnix-0.3prea0484a2c19d1947c21f11b4fc7c3f6049bd11efa.tar.gz;
    sha256 = "06qjaxysnkm31rgjlqy9n7p59q5v3jl57jm9jya7zf2g90syhdn7";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
