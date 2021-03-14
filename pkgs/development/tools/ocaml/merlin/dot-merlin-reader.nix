{ lib, fetchurl, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "dot-merlin-reader";
  version = "3.4.2";

  useDune2 = true;

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "109ai1ggnkrwbzsl1wdalikvs1zx940m6n65jllxj68in6bvidz1";
  };

  buildInputs = [ yojson csexp result ];

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
