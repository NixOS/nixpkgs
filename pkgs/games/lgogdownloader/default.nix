{ stdenv, fetchFromGitHub, curl, boost, jsoncpp, liboauth, rhash, tinyxml, htmlcxx, help2man }:

stdenv.mkDerivation rec {
  name = "lgogdownloader-${version}";
  version = "2.26";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "v${version}";
    sha256 = "0277g70nvq7bh42gnry7lz7wqhw8wl2hq6sfxwhn8x4ybkalj2gx";
  };

  buildInputs = [ curl boost jsoncpp liboauth rhash tinyxml htmlcxx help2man ];

  makeFlags = [ "release" "PREFIX=$(out)" ];

  meta = {
    homepage = https://github.com/Sude-/lgogdownloader;
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.linux;
  };
}
