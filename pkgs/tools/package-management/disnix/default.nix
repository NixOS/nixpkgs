{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre25135";
  src = fetchurl {
    url = http://hydra.nixos.org/build/811133/download/4/disnix-0.2pre25135.tar.gz;
    sha256 = "0ivblsgbl6fc4vqhs8zjw2qn463qlhnlzb5h34zyl0lya6wggcsd";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
