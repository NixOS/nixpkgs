{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, gettext, nixUnstable, dysnomia, libintl, libiconv, help2man, doclifter, docbook5, dblatex, doxygen, libnixxml, autoreconfHook }:

stdenv.mkDerivation {
  name = "disnix-0.10";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnix/releases/download/disnix-0.10/disnix-0.10.tar.gz";
    sha256 = "0mciqbc2h60nc0i6pd36w0m2yr96v97ybrzrqzh5f67ac1f0gqwg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 libxslt getopt nixUnstable libintl libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ sander tomberek ];
    platforms = stdenv.lib.platforms.unix;
  };
}
