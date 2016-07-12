{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, boost, liboauth, jsoncpp
, htmlcxx, rhash, tinyxml, help2man }:

stdenv.mkDerivation rec {
  name = "lgogdownloader-${version}";
  version = "2.28";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "v${version}";
    sha256 = "1xn6pfvxz496sj5jiqyzqj6vn6vrzyks9f6xha8g4vy6hkw717ag";
  };

  nativeBuildInputs = [ cmake pkgconfig help2man ];

  buildInputs = [ curl boost liboauth jsoncpp htmlcxx rhash tinyxml ];

  meta = {
    homepage = https://github.com/Sude-/lgogdownloader;
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.linux;
  };
}
