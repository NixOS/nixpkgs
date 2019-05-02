{ stdenv, fetchFromGitHub, libpng, pkgconfig, SDL, freetype, zlib }:

stdenv.mkDerivation rec {

  pname = "caprice32";
  version = "4.5.0";

  src = fetchFromGitHub {
    repo = "caprice32";
    rev = "v${version}";
    owner = "ColinPitrat";
    sha256 = "056vrf5yq1574g93ix8hnjqqbdqza3qcjv0f8rvpsslqcbizma9y";
  };

  postPatch = "substituteInPlace cap32.cfg --replace /usr/local $out";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng SDL freetype zlib ];

  #fix GIT_HASH avoid depend on git 
  makeFlags = [ "GIT_HASH=${src.rev}" "DESTDIR=$(out)" "prefix=/"];

  meta = with stdenv.lib; {
    description = "A complete emulation of CPC464, CPC664 and CPC6128";
    homepage = https://github.com/ColinPitrat/caprice32 ;
    license = licenses.gpl2;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };  
}
