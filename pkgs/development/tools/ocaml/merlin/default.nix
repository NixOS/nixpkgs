{ lib, fetchurl, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.3";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "05dfkbpbb7nvs4g6y0iw7a9f73ygvhs9l45l2g56y7zagvs9x43j";
  };

  buildInputs = [ yojson ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
