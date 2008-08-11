{stdenv, fetchurl, pkgconfig, glib, fuse}:

stdenv.mkDerivation {
  name = "sshfs-fuse-2.1";
  
  src = fetchurl {
    url = mirror://sourceforge/fuse/sshfs-fuse-2.1.tar.gz;
    sha256 = "0cyjq8dwrv3rhj7a52sd3fmljh5fdphlsnvqx51v6hbgd3jgld0j";
  };
  
  buildInputs = [pkgconfig glib fuse];

  meta = {
    homepage = http://fuse.sourceforge.net/sshfs.html;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
  };
}
