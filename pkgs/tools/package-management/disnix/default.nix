{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre0d9af6829c047d9a6fb27bff38af02e9e75ce36f";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/19868273/download/4/disnix-0.3pre0d9af6829c047d9a6fb27bff38af02e9e75ce36f.tar.gz;
    sha256 = "1d4p913mk9dbs8vda5cv02rzcrsdj5klwnxp4ana6qss74lh9415";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
