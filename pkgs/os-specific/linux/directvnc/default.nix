{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, directfb, zlib, libjpeg, xorgproto }:

stdenv.mkDerivation rec {
  name = "directvnc-${version}";
  version = "0.7.7.2015-04-16";

  src = fetchFromGitHub {
    owner = "drinkmilk";
    repo = "directvnc";
    rev = "d336f586c5865da68873960092b7b5fbc9f8617a";
    sha256 = "16x7mr7x728qw7nbi6rqhrwsy73zsbpiz8pbgfzfl2aqhfdiz88b";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ directfb zlib libjpeg xorgproto ];

  meta = with stdenv.lib; {
    description = "DirectFB VNC client";
    homepage = http://drinkmilk.github.io/directvnc/;
    license = licenses.gpl2;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
