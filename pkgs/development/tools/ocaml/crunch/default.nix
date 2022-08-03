{ lib, buildDunePackage, fetchurl, ocaml, cmdliner_1_1, ptime }:

buildDunePackage rec {

  pname = "crunch";
  version = "3.3.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-crunch/releases/download/v${version}/crunch-${version}.tbz";
    sha256 = "0b6mqr5nlijhn0r0cryz72yk32x5vqnnp1c6zvpppqg7f7hf312q";
  };

  propagatedBuildInputs = [ cmdliner_1_1 ptime ];

  outputs = [ "lib" "bin" "out" ];

  installPhase = ''
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = {
    homepage = "https://github.com/mirage/ocaml-crunch";
    description = "Convert a filesystem into a static OCaml module";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
