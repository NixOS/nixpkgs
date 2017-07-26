{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  version = "1.2.6";
  name = "redo-sh-${version}";

  src = fetchurl {
    url = "http://news.dieweltistgarnichtso.net/bin/archives/redo-sh.tar.gz";
    sha256 = "1cwrk4v22rb9410rzyb4py4ncg01n6850l80s74bk3sflbw974wp";
  };

  buildInputs = [ makeWrapper ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/share"
    mv man "$out/share"
    mv bin "$out"
    for p in $out/bin/*; do
      wrapProgram "$p" --set PATH '$PATH:'"$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Redo implementation in Bourne Shell";
    homepage = "http://news.dieweltistgarnichtso.net/bin/redo-sh.html";
    license  = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
