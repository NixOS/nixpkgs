{ stdenv, fetchgit, makeWrapper, curl, spidermonkey }:

stdenv.mkDerivation rec {

  name = "plowshare4-${version}";

  version = "1.1.0";

  src = fetchgit {
    url = "https://code.google.com/p/plowshare/";
    rev = "87bd955e681ddda05009ca8594d727260989d5ed";
    sha256 = "0cbsnalmr6fa1ijsn1j1p9fdqi3ii96bx3xabgvvbbqkl7q938f9";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${curl}/bin:${spidermonkey}/bin"
    done
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
  };
}
