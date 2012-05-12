{ stdenv, fetchurl, pkgconfig, glib, fuse }:

stdenv.mkDerivation rec {
  name = "sshfs-fuse-2.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "1ladfxflg0pzd5br0p9n5790sf1975va7igr9z4r702n4a2vm4rw";
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
