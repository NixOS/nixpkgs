{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, gettext, nixUnstable, dysnomia, libintl, libiconv, help2man, doclifter, docbook5, dblatex, doxygen, libnixxml, autoreconfHook }:

stdenv.mkDerivation {
  name = "disnix-0.9.1";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnix/releases/download/disnix-0.9.1/disnix-0.9.1.tar.gz";
    sha256 = "0bidln5xw3raqkvdks9aipis8aaza8asgyapmilnxkkrxgmw7rdf";
  };

  configureFlags = [
    " --with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 libxslt getopt nixUnstable libintl libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ sander tomberek ];
    platforms = stdenv.lib.platforms.unix;
  };
}
