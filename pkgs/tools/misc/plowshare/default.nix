{ stdenv, fetchurl, makeWrapper, curl }:

let

  v  = "20120807";

in stdenv.mkDerivation {

  name = "plowshare-git${v}";

  src = fetchurl {
    url = "http://plowshare.googlecode.com/files/plowshare-snapshot-git${v}.tar.gz";
    sha256 = "0clryfssaa4rjvsy760p51ppq1275lwvhm9jh3g4mi973xv4n8si";
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
