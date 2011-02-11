{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre25894";
  src = fetchurl {
    url = http://hydra.nixos.org/build/895051/download/4/disnix-0.2pre25894.tar.gz;
    sha256 = "0f8d2hnz67ykksw6l6izf06r9w7dkmlfb4dv6waxz9r7ylaardg2";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
