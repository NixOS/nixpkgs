{stdenv, fetchurl, pkgconfig, glib, fuse}:

stdenv.mkDerivation {
  name = "sshfs-fuse-1.7";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/fuse/sshfs-fuse-1.7.tar.gz;
    md5 = "e91a2fed1da952a375798408dc6e41a0";
  };
  buildInputs = [pkgconfig glib fuse];
}
