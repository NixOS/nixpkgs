{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  cmdliner,
  ptime,
}:

buildDunePackage rec {

  pname = "crunch";
  version = "4.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-crunch/releases/download/v${version}/crunch-${version}.tbz";
    sha256 = "sha256-k5uNESntbGNMsPnMxvbUSqFwPNBc5gkfLuKgFilEuJs=";
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

}
