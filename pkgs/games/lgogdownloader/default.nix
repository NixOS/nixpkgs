{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, boost, liboauth, jsoncpp
, htmlcxx, rhash, tinyxml-2, help2man }:

stdenv.mkDerivation rec {
  name = "lgogdownloader-${version}";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "v${version}";
    sha256 = "056idwwxjcp2zjqk5h7l3py1h45sax4vbsm93bz9shnfx1s1h3gc";
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
