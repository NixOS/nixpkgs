{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja, glib, fuse3
, docutils, which, python3Packages
}:

stdenv.mkDerivation rec {
  version = "3.4.0";
  name = "sshfs-fuse-${version}";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "1mbhjgw6797bln579pfwmn79gs8isnv57z431lbfw7j8xkh75awl";
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

  checkInputs = [ which ] ++ (with python3Packages; [ python pytest ]);

  checkPhase = ''
    python3 -m pytest test/
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ primeos ];
  };
}
