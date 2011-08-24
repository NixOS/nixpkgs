{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.3pre27244";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1083290/download/4/disnix-0.3pre27244.tar.gz;
    sha256 = "1x7y34mxs26k019y9y8fsnzdk7wmjqfmybw99qgqqxy5kblvlzns";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
