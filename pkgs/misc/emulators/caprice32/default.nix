{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib }:

stdenv.mkDerivation rec {

  pname = "caprice32";
  version = "4.6.0";

  src = fetchFromGitHub {
    repo = "caprice32";
    rev = "v${version}";
    owner = "ColinPitrat";
    sha256 = "0hng5krwgc1h9bz1xlkp2hwnvas965nd7sb3z9mb2m6x9ghxlacz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];

  makeFlags = [
    "APP_PATH=${placeholder ''out''}/share/caprice32/"
    "RELEASE=1"
    #"WITH_IPF=0"
    "DESTDIR=${placeholder ''out''}"
    "prefix=/"
  ];

  meta = with stdenv.lib; {
    description = "A complete emulation of CPC464, CPC664 and CPC6128";
    homepage = "https://github.com/ColinPitrat/caprice32";
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
