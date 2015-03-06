{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3precd3288b47c8e7205268d6afb066e21b9d114f797";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20137290/download/4/disnix-0.3precd3288b47c8e7205268d6afb066e21b9d114f797.tar.gz;
    sha256 = "1n1m4kr9xp60kkrcx92npc6hh3gi36njzxmds7nw9mz0pccqbci1";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
