{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.7.1";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnix/releases/download/disnix-0.7.1/disnix-0.7.1.tar.gz;
    sha256 = "0wxik73bk3hh4xjjj8jcgrwv1722m7cqgpiiwjsgxs346jvhrv2s";
  };
  
  buildInputs = [ pkgconfig glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
