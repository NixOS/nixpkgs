{ stdenv, fetchurl, qmake, qttools, qtsvg, mkDerivation }:

mkDerivation rec {
  pname = "cutemaze";
  version = "1.2.5";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${pname}-${version}-src.tar.bz2";
    sha256 = "1xrjv3h1bpbji1dl9hkcvmp6qk4j618saffl41455vhrzn170lrj";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtsvg ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv CuteMaze.app $out/Applications
  '';

  meta = with stdenv.lib; {
    homepage = https://gottcode.org/cutemaze/;
    description = "Simple, top-down game in which mazes are randomly generated";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
