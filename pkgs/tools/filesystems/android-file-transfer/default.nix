{ lib, stdenv, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  name = "android-file-transfer-${version}";
  version = "3.5";
  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "036hca41ikgnw4maykjdp53l31rm01mgamy9y56i5qqh84cwmls2";
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
