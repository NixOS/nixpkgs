{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre30527";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/1926928/download/4/disnix-0.3pre30527.tar.gz;
    sha256 = "1mdcxyrz60nxcyn116i41nhh94r9hacvyilkjyjfiyf8d58pji1y";
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
