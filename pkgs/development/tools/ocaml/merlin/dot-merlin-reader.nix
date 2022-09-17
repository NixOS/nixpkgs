{ lib, fetchurl, yojson, csexp, buildDunePackage, merlin-lib, merlin }:

buildDunePackage rec {
  pname = "dot-merlin-reader";

  inherit (merlin) version src;

  minimalOCamlVersion = "4.06";

  buildInputs = if lib.versionAtLeast version "4.6-414"
  then [ merlin-lib ]
  else [ yojson csexp ];

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
