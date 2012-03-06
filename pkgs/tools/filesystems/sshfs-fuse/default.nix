{ stdenv, fetchurl, pkgconfig, glib, fuse }:

stdenv.mkDerivation rec {
  name = "sshfs-fuse-2.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "08sl7q8nqwg57bxbzp2wb9h204gnl1w9c1f7zjdh7xdr9jybqvi0";
  };
  
  buildInputs = [ pkgconfig glib fuse ];
  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
  '';

  meta = {
    homepage = http://fuse.sourceforge.net/sshfs.html;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = stdenv.lib.platforms.linux;
  };
}
