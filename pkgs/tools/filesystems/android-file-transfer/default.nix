{ stdenv, mkDerivation, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase }:

mkDerivation rec {
  pname = "android-file-transfer";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "1pwayyd5xrmngfrmv2vwr8ns2wi199xkxf7dks8fl9zmlpizg3c3";
  };

  nativeBuildInputs = [ cmake readline pkgconfig ];
  buildInputs = [ fuse qtbase ];

  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
