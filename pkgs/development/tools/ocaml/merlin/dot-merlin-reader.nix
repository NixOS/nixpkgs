{ lib, fetchurl, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "dot-merlin-reader";
  version = "3.4.0";

  minimumOCamlVersion = "4.02.1";

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = "048rkpbvayksv8mgmkgi17vv0y9xplv7v2ww4d1hs7bkm5zzsvg2";
  };

  buildInputs = [ yojson csexp result ];

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
