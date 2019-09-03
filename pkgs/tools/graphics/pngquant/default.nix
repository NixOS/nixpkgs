{ stdenv, fetchFromGitHub, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "pornel";
    repo = "pngquant";
    rev = version;
    sha256 = "0jdvry3kvmmxcgwf5a3zbfz0idl6yl3700ag7pf8sk4lg4qp0llp";
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
