{ stdenv, fetchFromGitHub, pkgconfig, glib, fuse, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "sshfs-fuse-2.6";
  
  src = fetchFromGitHub {
    repo = "sshfs";
    owner = "libfuse";
    rev = "sshfs_2_6";
    sha256 = "08ffvviinjf8ncs8z494q739a8lky9z46i09ghj1y38qzgvk3fpw";
  };
  
  buildInputs = [ pkgconfig glib fuse autoreconfHook ];

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
