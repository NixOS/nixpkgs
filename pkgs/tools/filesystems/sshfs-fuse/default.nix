{ stdenv, fetchurl, pkgconfig, glib, fuse }:

stdenv.mkDerivation rec {
  name = "sshfs-fuse-2.5";
  
  src = fetchurl {
    url = "mirror://sourceforge/fuse/${name}.tar.gz";
    sha256 = "0gp6qr33l2p0964j0kds0dfmvyyf5lpgsn11daf0n5fhwm9185z9";
  };
  
  buildInputs = [ pkgconfig glib fuse ];
  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/libfuse/sshfs;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
