{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.0.3";
  pname = "redo-sh";

  src = fetchurl {
    url = "http://news.dieweltistgarnichtso.net/bin/archives/redo-sh.tar.gz";
    sha256 = "1ycx3hik7vnlbwxacn1dzr48fwsn2ials0sg6k9l3gcyrha5wf1n";
  };

  buildInputs = [ makeWrapper ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/share"
    mv man "$out/share"
    mv bin "$out"
    for p in $out/bin/*; do
      wrapProgram "$p" --suffix PATH : "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Redo implementation in Bourne Shell";
    homepage = http://news.dieweltistgarnichtso.net/bin/redo-sh.html;
    license  = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
