{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja, glib, fuse3
, docutils
}:

let
  inherit (stdenv.lib) optional;
in stdenv.mkDerivation rec {
  version = "3.3.1";
  name = "sshfs-fuse-${version}";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "15z1mlad09llckkadvjfzmbv14fbq218xmb4axkmi7kzixbi41hv";
  };

  nativeBuildInputs = [ meson pkgconfig ninja docutils ];
  buildInputs = [ fuse3 glib ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optional
    (stdenv.system == "i686-linux")
    "-D_FILE_OFFSET_BITS=64";

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
