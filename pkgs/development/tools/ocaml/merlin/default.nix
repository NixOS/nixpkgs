{ lib, fetchurl, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.8";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "0j27piq9hqhr2jp89ni73kchw33pcx7gnjkh8rd6qa8hc12xd794";
  };

  buildInputs = [ yojson ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
