{stdenv, fetchurl, pkgconfig, glib, gtk, libxml2}:

stdenv.mkDerivation {
  name = "gtk-gnutella-0.96.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gtk-gnutella-0.96.1.tar.bz2;
    md5 = "6529379cc105c1e98f501a67e8e875fd";
  };
  buildInputs = [pkgconfig glib gtk libxml2];
}
