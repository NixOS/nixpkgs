{ stdenv, fetchFromGitHub, automake, autoconf, libtool, gettext, utillinux, openisns, openssl, kmod }:
stdenv.mkDerivation rec {
  name = "open-iscsi-${version}";
  version = "2.0-873-${stdenv.lib.substring 0 7 src.rev}";

  buildInputs = [ automake autoconf libtool gettext utillinux openisns.lib openssl kmod ];
  
  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = "4c1f2d90ef1c73e33d9f1e4ae9c206ffe015a8f9";
    sha256 = "0h030zk4zih3l8z5662b3kcifdxlakbwwkz1afb7yf0cicds7va8";
  };
  
  DESTDIR = "$(out)";
  
  NIX_LDFLAGS = "-lkmod";
  NIX_CFLAGS_COMPILE = "-DUSE_KMOD";

  preConfigure = ''
    sed -i 's|/usr|/|' Makefile
  '';
  
  postInstall = ''
    cp usr/iscsistart $out/sbin/
    $out/sbin/iscsistart -v
  '';

  meta = with stdenv.lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2Plus;
    homepage = http://www.open-iscsi.com;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cleverca22 ];
  };
}
