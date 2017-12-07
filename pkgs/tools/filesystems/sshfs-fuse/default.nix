{ stdenv, fetchFromGitHub, pkgconfig, glib, fuse, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "2.10"; # Temporary (need to add libfuse 3.x first)
  name = "sshfs-fuse-${version}";
  
  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "1dmw4kx6vyawcywiv8drrajnam0m29mxfswcp4209qafzx3mjlp1";
  };
  
  buildInputs = [ pkgconfig glib fuse autoreconfHook ];

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
