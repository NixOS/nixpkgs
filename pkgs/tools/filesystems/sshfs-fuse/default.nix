{ stdenv, fetchFromGitHub, pkgconfig, glib, fuse, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "2.7";
  name = "sshfs-fuse-${version}";
  
  src = fetchFromGitHub {
    repo = "sshfs";
    owner = "libfuse";
    rev = "sshfs-${version}";
    sha256 = "17l9b89zy5qzfcknw3krk74rfrqaa8q1r8jwdsahaqajsy09h4x4";
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
