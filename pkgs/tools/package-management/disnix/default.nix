{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre32254";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/2368541/download/4/disnix-0.3pre32254.tar.gz;
    sha256 = "1jznx4mb6vwpzzpbk4c16j73hjgng7v1nraq8yya7f7m1s2gyhcw";
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
