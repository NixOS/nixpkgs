{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre25258";
  src = fetchurl {
    url = http://hydra.nixos.org/build/824993/download/4/disnix-0.2pre25258.tar.gz;
    sha256 = "1lj1mji34s79vhs6r8mcm8l5njbvs9m17nn5r16yqz820wisr4a7";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
