{ stdenv, fetchurl, pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.6.1";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/40497264/download/4/disnix-0.6.1.tar.gz;
    sha256 = "123y8vp31sl394rl7pg2xy13ng9i3pk4s7skyqhngjbqzjl72lhj";
  };
  
  buildInputs = [ pkgconfig glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
