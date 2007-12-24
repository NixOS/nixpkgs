{stdenv, fetchurl, pkgconfig, glib, fuse}:

stdenv.mkDerivation {
  name = "sshfs-fuse-1.9";
  src = fetchurl {
    url = mirror://sourceforge/fuse/sshfs-fuse-1.9.tar.gz;
    sha256 = "10ishsghdwd6a1cd36gp26qpch6z8d6wjs7aw8vs0ffnvrs4hdza";
  };
  buildInputs = [pkgconfig glib fuse];

  meta = {
    homepage = http://fuse.sourceforge.net/sshfs.html;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
  };
}
