{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib }:

stdenv.mkDerivation rec {

  repo = "caprice32";
  version = "unstable-2018-03-05";
  rev = "317fe638111e245d67e301f6f295094d3c859a70";
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit rev repo;
    owner = "ColinPitrat";
    sha256 = "1bywpmkizixcnr057k8zq9nlw0zhcmwkiriln0krgdcm7d3h9b86";
  };

  postPatch = "substituteInPlace cap32.cfg --replace /usr/local $out";

  meta = with stdenv.lib; {
    description = "A complete emulation of CPC464, CPC664 and CPC6128";
    homepage = https://github.com/ColinPitrat/caprice32 ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];
  makeFlags = [ "GIT_HASH=${src.rev}" "DESTDIR=$(out)" "prefix=/"];
}
