{ stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation {
  version = "4.0.3";
  pname = "redo-sh";

  src = fetchurl {
    url = "http://news.dieweltistgarnichtso.net/bin/archives/redo-sh.tar.gz";
    sha256 = "1n84ld4fihqa7a6kn3f177dknz89qcvissfwz1m21bwdq950avia";
  };

  buildInputs = [ makeWrapper ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/share"
    mv man "$out/share"
    mv bin "$out"
    for p in $out/bin/*; do
      wrapProgram "$p" --prefix PATH : "$out/bin:${coreutils}/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Redo implementation in Bourne Shell";
    homepage = "http://news.dieweltistgarnichtso.net/bin/redo-sh.html";
    license  = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
