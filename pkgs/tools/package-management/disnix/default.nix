{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre34664";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/4072223/download/4/disnix-0.3pre34664.tar.gz;
    sha256 = "4e20a73c17061428ea66abd6004aaaa71b273ac88fca8e569a2262ae1f246c52";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
                ++ stdenv.lib.optional (!stdenv.isLinux) gettext;
                
  dontStrip = true;
  
  meta = {
    description = "A distributed deployment extension for Nix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
