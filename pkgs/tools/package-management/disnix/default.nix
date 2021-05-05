{ lib, stdenv, fetchurl, pkg-config, glib, libxml2, libxslt, getopt, gettext, dysnomia, libintl, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.10.1";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnix/releases/download/disnix-0.10.1/disnix-0.10.1.tar.gz";
    sha256 = "13rjw1va7l8w7ir73xqxq4zb3ig2iwhiwxhp5dbfv0z3gnqizghq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 libxslt getopt libintl libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
