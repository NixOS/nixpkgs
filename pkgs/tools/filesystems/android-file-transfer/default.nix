{ stdenv, mkDerivation, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase, qttools }:

mkDerivation rec {
  pname = "android-file-transfer";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "11d4n4ybmc25gz18nlps3v11m3y8dw5bcb817gkik5m4nvqnbcsf";
  };

  nativeBuildInputs = [ cmake readline pkgconfig ];
  buildInputs = [ fuse qtbase qttools ];

  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
