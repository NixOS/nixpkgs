{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconvOrEmpty }:

stdenv.mkDerivation {
  name = "disnix-0.3pre24d959b3b37ce285971810245643a7f18cb85fcc";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/13612993/download/4/disnix-0.3pre24d959b3b37ce285971810245643a7f18cb85fcc.tar.gz;
    sha256 = "0ml8g6h7x79mvv84il9vb9b88kqak9m3yzavmar66i3dvyqr1dwb";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconvOrEmpty dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
