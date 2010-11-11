{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre24517";
  src = fetchurl {
    url = http://hydra.nixos.org/build/720966/download/3/disnix-0.2pre24517.tar.gz;
    sha256 = "03d2w9kckk8hy2xrywb5mk5qiyd9kjxabihv1rjnc3grlzi053k4";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
