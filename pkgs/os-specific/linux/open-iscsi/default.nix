{ stdenv, fetchFromGitHub, nukeReferences, automake, autoconf, libtool, gettext, utillinux, openisns, openssl }:
stdenv.mkDerivation rec {
  name = "open-iscsi-${version}";
  version = "2.0-873-${stdenv.lib.substring 0 7 src.rev}";
  outputs = [ "out" "iscsistart" ];

  buildInputs = [ nukeReferences automake autoconf libtool gettext utillinux openisns.lib openssl ];
  
  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = "4c1f2d90ef1c73e33d9f1e4ae9c206ffe015a8f9";
    sha256 = "0h030zk4zih3l8z5662b3kcifdxlakbwwkz1afb7yf0cicds7va8";
  };
  
  DESTDIR = "$(out)";
  
  preConfigure = ''
    sed -i 's|/usr/|/|' Makefile
  '';
  
  postInstall = ''
    mkdir -pv $iscsistart/bin/
    cp -v usr/iscsistart $iscsistart/bin/
    nuke-refs $iscsistart/bin/iscsistart
  '';

  meta = with stdenv.lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2Plus;
    homepage = http://www.open-iscsi.com;
    platforms = platforms.linux;
  };
}
