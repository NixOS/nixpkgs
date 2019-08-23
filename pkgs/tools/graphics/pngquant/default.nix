{ stdenv, fetchFromGitHub, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.12.5";

  src = fetchFromGitHub {
    owner = "pornel";
    repo = "pngquant";
    rev = version;
    sha256 = "0sq398iv5cacblz6pb4j2hn16cnszsbkahikdpfq84rb9bj0ya40";
    fetchSubmodules = true;
  };

  preConfigure = "patchShebangs .";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng zlib lcms2 ];

  meta = with stdenv.lib; {
    homepage = https://pngquant.org/;
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.volth ];
  };
}
