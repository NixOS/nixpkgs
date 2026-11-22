{
  lib,
  buildDunePackage,
  fetchurl,
  cmdliner,
  ptime,
}:

buildDunePackage (finalAttrs: {
  pname = "crunch";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-crunch/releases/download/v${finalAttrs.version}/crunch-${finalAttrs.version}.tbz";
    hash = "sha256-t3ddb7bmCUqMMf2/ISdQHZntjO6sQCcQVd1Sx5o+F+c=";
  };

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [ ptime ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-crunch";
    description = "Convert a filesystem into a static OCaml module";
    mainProgram = "ocaml-crunch";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

})
