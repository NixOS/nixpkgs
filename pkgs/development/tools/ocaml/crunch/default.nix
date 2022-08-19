{ lib, buildDunePackage, fetchurl, ocaml, cmdliner_1_1, ptime }:

buildDunePackage rec {

  pname = "crunch";
  version = "3.3.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-crunch/releases/download/v${version}/crunch-${version}.tbz";
    sha256 = "sha256-LFug1BELy7dzHLpOr7bESnSHw/iMGtR0AScbaf+o7Wo=";
  };

  buildInputs = [ cmdliner_1_1 ];

  propagatedBuildInputs = [ ptime ];

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
