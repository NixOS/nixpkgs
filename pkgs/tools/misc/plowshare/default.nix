{ stdenv, fetchurl, makeWrapper, curl }:

stdenv.mkDerivation rec {

  name = "plowshare-${version}";

  version = "git20120916";

  src = fetchurl {
    url = "http://plowshare.googlecode.com/files/plowshare-snapshot-${version}.tar.gz";
    sha256 = "eccdb28d49ac47782abc8614202b3a88426cd587371641ecf2ec008880dc6067";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${curl}/bin"
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
