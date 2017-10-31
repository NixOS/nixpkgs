{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, boost, liboauth, jsoncpp
, htmlcxx, rhash, tinyxml-2, help2man }:

stdenv.mkDerivation rec {
  name = "lgogdownloader-${version}";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "v${version}";
    sha256 = "0p1zh2l8g4y2z02xj0fndbfhcxgcpwhf5d9izwsdi3yljvqv23np";
  };

  nativeBuildInputs = [ cmake pkgconfig help2man ];

  buildInputs = [ curl boost liboauth jsoncpp htmlcxx rhash tinyxml-2 ];

  meta = {
    homepage = https://github.com/Sude-/lgogdownloader;
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.linux;
  };
}
