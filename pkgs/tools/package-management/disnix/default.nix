{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.8";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnix/files/1756701/disnix-0.8.tar.gz;
    sha256 = "02cmj1jqk5i90szjsn5csr7qb7n42v04rvl9syx0zi9sx9ldnb0w";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
