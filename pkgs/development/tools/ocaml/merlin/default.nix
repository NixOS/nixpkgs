{ lib, fetchurl, buildDunePackage, substituteAll
, dot-merlin-reader, dune_2, yojson, csexp, result }:

buildDunePackage rec {
  pname = "merlin";

  inherit (dot-merlin-reader) src version;

  minimumOCamlVersion = "4.02.3";

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
  ];

  buildInputs = [ dot-merlin-reader yojson csexp result ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
