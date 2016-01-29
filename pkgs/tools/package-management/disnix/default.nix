{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.5";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/31143411/download/4/disnix-0.5.tar.gz;
    sha256 = "0v0gbbcspaj67sn8ncrripa5af0m2xykyjjn2n55smz5fwx6d124";
  };
  
  buildInputs = [ pkgconfig glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
