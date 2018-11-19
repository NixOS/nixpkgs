{ lib, stdenv, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  name = "android-file-transfer-${version}";
  version = "3.6";
  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "0gaj1shmd62ks4cjdcmiqczlr93v8ivjcg0l6s8z73cz9pf8dxmz";
  };
  buildInputs = [ cmake fuse readline pkgconfig qtbase ];
  buildPhase = ''
    cmake .
    make
  '';
  installPhase = ''
    make install
  '';
  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = https://whoozle.github.io/android-file-transfer-linux/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
