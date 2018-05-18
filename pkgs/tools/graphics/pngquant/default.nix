{ stdenv, fetchgit, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  name = "pngquant-${version}";
  version = "2.11.7";

  src = fetchgit {
    url = "https://www.github.com/pornel/pngquant.git";
    rev = "refs/tags/${version}";
    sha256 = "1qr5qr2wznzp0v9xwyz4r3982rcm9kys913w8gwmv7qd1akvx2qh";
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
