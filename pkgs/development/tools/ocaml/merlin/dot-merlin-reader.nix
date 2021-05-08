{ lib, fetchurl, yojson, csexp, result, buildDunePackage }:

buildDunePackage rec {
  pname = "dot-merlin-reader";
  version = "4.1";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/dot-merlin-reader-v${version}.tbz";
    sha256 = "14a36d6fb8646a5df4530420a7861722f1a4ee04753717947305e3676031e7cd";
  };

  buildInputs = [ yojson csexp result ];

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
