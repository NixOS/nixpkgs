{
  lib,
  yojson,
  csexp,
  findlib,
  buildDunePackage,
  merlin-lib,
  merlin,
  result,
}:

buildDunePackage rec {
  pname = "dot-merlin-reader";

  inherit (merlin) version src;

  minimalOCamlVersion = "4.06";

  buildInputs = [
    findlib
  ]
  ++ (
    if lib.versionAtLeast version "4.7-414" then
      [ merlin-lib ]
    else
      [
        yojson
        csexp
        result
      ]
  );

  meta = {
    description = "Reads config files for merlin";
    mainProgram = "dot-merlin-reader";
    homepage = "https://github.com/ocaml/merlin";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hongchangwu ];
  };
}
