{ lib, stdenv, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  name = "android-file-transfer-${version}";
  version = "3.7";
  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "0a388pqc0azgn0wy85wb1mjk3b5zb6vcr58l4warwfzhca400zn0";
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
