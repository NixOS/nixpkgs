{ stdenv, fetchFromGitHub, pkgconfig, glib, fuse3, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "sshfs-fuse-${version}";
  
  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "09pqdibhcj1p7m6vxkqiprvbcxp9iq2lm1hb6w7p8iarmvp80rlv";
  };
  
  buildInputs = [ pkgconfig glib fuse3 autoreconfHook ];

  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
