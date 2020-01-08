{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintl, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.9.1";

  src = fetchurl {
    url = https://github.com/svanderburg/disnix/releases/download/disnix-0.9.1/disnix-0.9.1.tar.gz;
    sha256 = "0bidln5xw3raqkvdks9aipis8aaza8asgyapmilnxkkrxgmw7rdf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 libxslt getopt nixUnstable libintl libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
