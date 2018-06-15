{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib }:

stdenv.mkDerivation rec {

  repo = "caprice32";
  version = "unstable-2018-02-10";
  rev = "53de69543300f81af85df32cbd21bb5c68cab61e";
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    inherit rev repo;
    owner = "ColinPitrat";
    sha256 = "12yv56blm49qmshpk4mgc802bs51wv2ra87hmcbf2wxma39c45fy";
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
