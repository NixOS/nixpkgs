{ stdenv, fetchurl, qmake, qttools, qtsvg }:

stdenv.mkDerivation rec {
  name = "cutemaze-${version}";
  version = "1.2.3";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${name}-src.tar.bz2";
    sha256 = "1gczg8bki9d2kkkkrac5wi4vnjdynv8xjw2qxn9lx1jfkm8fk1qk";
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
