{ lib, stdenv, fetchFromGitHub, pkg-config, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "pngquant";
    rev = version;
    sha256 = "0ny6h3fwf6gvzkqkc3zb5mrkqxm6s7xzb6bvzn6vlamklncqgl78";
    fetchSubmodules = true;
  };

  preConfigure = "patchShebangs .";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpng zlib lcms2 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://pngquant.org/";
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    changelog = "https://github.com/kornelski/pngquant/raw/${version}/CHANGELOG";
    platforms = platforms.unix;
    license = with licenses; [ gpl3Plus hpnd bsd2 ];
    maintainers = [ maintainers.volth ];
  };
}
