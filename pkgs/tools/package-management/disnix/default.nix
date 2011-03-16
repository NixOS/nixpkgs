{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2.1";
  src = fetchurl {
    url = http://hydra.nixos.org/build/923387/download/4/disnix-0.2.1.tar.gz;
    sha256 = "1kablxlg7mxajg2r96im2xr3xjgwmqi2gahxyhn2mvb6555dn5h8";
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
