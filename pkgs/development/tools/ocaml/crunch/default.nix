{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
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

  outputs = [
    "lib"
    "bin"
    "out"
  ];

  installPhase = ''
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = {
    homepage = "https://github.com/mirage/ocaml-crunch";
    description = "Convert a filesystem into a static OCaml module";
    mainProgram = "ocaml-crunch";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

})
