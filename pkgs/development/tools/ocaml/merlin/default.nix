{ lib, fetchurl, buildDunePackage, substituteAll
, dot-merlin-reader, dune_2, yojson, csexp, result, menhirSdk }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.4.2";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "e1b7b897b11119d92995c558530149fd07bd67a4aaf140f55f3c4ffb5e882a81";
  };

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
  ];

  strictDeps = true;

  buildInputs = [ dot-merlin-reader yojson csexp result menhirSdk ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
