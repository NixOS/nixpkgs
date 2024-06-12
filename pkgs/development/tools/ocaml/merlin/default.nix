{ lib, fetchurl, buildDunePackage, substituteAll
, dot-merlin-reader, dune_2, yojson, csexp, result, menhirSdk }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.8.0";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
    sha256 = "sha256-wmBGNwXL3BduF4o1sUXtAOUHJ4xmMvsWAxl/QdNj/28=";
  };

  minimalOCamlVersion = "4.02.3";

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
    description = "Editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
