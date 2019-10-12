{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintl, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.9";

  src = fetchurl {
    url = https://github.com/svanderburg/disnix/releases/download/disnix-0.9/disnix-0.9.tar.gz;
    sha256 = "1kc4520zjc1z72mknylfvrsyda9rbmm5c9mw8w13zhdwg3zbna06";
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
