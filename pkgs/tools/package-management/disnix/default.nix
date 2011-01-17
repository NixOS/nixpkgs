{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre25538";
  src = fetchurl {
    url = http://hydra.nixos.org/build/856742/download/4/disnix-0.2pre25538.tar.gz;
    sha256 = "14cb5rhapsda2s22ys3d0i6qsfw4gnvc9483f5if3xr4hg6fgq0x";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
