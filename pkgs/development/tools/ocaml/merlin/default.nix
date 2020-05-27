{ lib, fetchurl, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.4";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "12wxric6n3rmsn0w16xm8vjd8p5aw24cj76zw2x87qfwwgmy1kdd";
  };

  buildInputs = [ yojson ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
