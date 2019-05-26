{ stdenv, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  pname = "android-file-transfer";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "0sym33a0ccdka2cpzv003n2xniid70z0gkjxx93gd2bajkgs9ggc";
  };

  nativeBuildInputs = [ cmake readline pkgconfig ];
  buildInputs = [ fuse qtbase ];

  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = https://whoozle.github.io/android-file-transfer-linux/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
