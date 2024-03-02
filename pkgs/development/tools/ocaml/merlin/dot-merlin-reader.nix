{ lib, fetchurl, yojson, csexp, findlib, buildDunePackage, merlin-lib, merlin, result }:

buildDunePackage rec {
  pname = "dot-merlin-reader";

  duneVersion = "3";

  inherit (merlin) version src;

  minimalOCamlVersion = "4.06";

  buildInputs = [ findlib ]
  ++ (if lib.versionAtLeast version "4.7-414"
  then [ merlin-lib ]
  else [ yojson csexp result ]);

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
