{ stdenv, fetchurl, qmake, qttools, qtsvg, mkDerivation }:

mkDerivation rec {
  pname = "cutemaze";
  version = "1.2.6";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${pname}-${version}-src.tar.bz2";
    sha256 = "0pw31j2i3ifndikhz9w684ia00r8zvcgnb66ign9w4lgs1zjgcrw";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtsvg ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv CuteMaze.app $out/Applications
  '';

  meta = with stdenv.lib; {
    homepage = "https://gottcode.org/cutemaze/";
    description = "Simple, top-down game in which mazes are randomly generated";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
