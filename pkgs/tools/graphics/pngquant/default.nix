{ lib, stdenv, fetchFromGitHub, pkg-config, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "pngquant";
    rev = version;
    sha256 = "054hi33qp3jc7hv0141wi8drwdg24v5zfp8znwjmz4mcdls8vxbb";
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
