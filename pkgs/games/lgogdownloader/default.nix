{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, boost, liboauth, jsoncpp
, htmlcxx, rhash, tinyxml-2, help2man, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "lgogdownloader";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "v${version}";
    sha256 = "0a3rrkgqwdqxx3ghzw182jx88gzzw6ldp3jasmgnr4l7gpxkmwws";
  };

  nativeBuildInputs = [ cmake pkgconfig help2man ];

  buildInputs = [ curl boost liboauth jsoncpp htmlcxx rhash tinyxml-2 ];

  patches = [
    # Fix find_path for newer jsoncpp. Remove with the next release
    (fetchpatch {
      url = "https://github.com/Sude-/lgogdownloader/commit/ff353126ecda61824cf866d3807c9ebada96282e.patch";
      sha256 = "1xr1lwxlrncrj662s9l1is1x1mhs1jbwlj8qafixz5hw2kx22w19";
    })
  ];

  meta = {
    homepage = https://github.com/Sude-/lgogdownloader;
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.linux;
  };
}
