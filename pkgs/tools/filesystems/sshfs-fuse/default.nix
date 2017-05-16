{ stdenv, fetchFromGitHub, pkgconfig, glib, fuse, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "2.9";
  name = "sshfs-fuse-${version}";
  
  src = fetchFromGitHub {
    repo = "sshfs";
    owner = "libfuse";
    rev = "sshfs-${version}";
    sha256 = "1n0cq72ps4dzsh72fgfprqn8vcfr7ilrkvhzpy5500wjg88diapv";
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
