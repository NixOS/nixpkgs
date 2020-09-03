{ lib, fetchurl, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.9";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "00ng8299l5rzpak8ljxzr6dgxw6z52ivm91159ahv09xk4d0y5x3";
  };

  buildInputs = [ yojson ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
