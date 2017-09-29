{ stdenv, fetchgit, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  name = "pngquant-${version}";
  version = "2.9.1";

  src = fetchgit {
    url = "https://www.github.com/pornel/pngquant.git";
    rev = "refs/tags/${version}";
    sha256 = "0xhnrjsk55jy5q68f81y7l61c6x18i4fzkm3i4dgndrhri5g4n1q";
    fetchSubmodules = true;
  };

  preConfigure = "patchShebangs .";

  buildInputs = [ pkgconfig libpng zlib lcms2 ];

  meta = with stdenv.lib; {
    homepage = https://pngquant.org/;
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.volth ];
  };
}
