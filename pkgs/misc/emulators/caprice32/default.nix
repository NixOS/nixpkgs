{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib, mesa }:

stdenv.mkDerivation rec {

  pname = "caprice32";
  version = "2018-02-10";
  rev = "53de69543300f81af85df32cbd21bb5c68cab61e";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${pname}-${version}-${short_rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ColinPitrat";
    repo  = "caprice32";
    sha256 = "12yv56blm49qmshpk4mgc802bs51wv2ra87hmcbf2wxma39c45fy";
  };

  postPatch = "substituteInPlace cap32.cfg --replace /usr/local $out";

  meta = with stdenv.lib; {
    description = "A complete emulation of CPC464, CPC664 and CPC6128";
    homepage = https://github.com/ColinPitrat/caprice32 ;
    license = licenses.gpl2;
    maintainers = [ maintainers.bignaux ];
    platforms = platforms.linux;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];
  makeFlags = [ "GIT_HASH=${src.rev}" "DESTDIR=$(out)" "prefix=/"];
}
