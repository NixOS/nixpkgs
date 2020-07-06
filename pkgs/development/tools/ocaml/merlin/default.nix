{ lib, fetchurl, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.6";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "1360cm0jkn2v2y5p3yzdyw9661a1vpddcibkbfblmk95qafx4civ";
  };

  buildInputs = [ yojson ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
