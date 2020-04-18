{ lib, buildDunePackage, fetchurl, ocaml, cmdliner, opaline, ptime }:

buildDunePackage rec {

  pname = "crunch";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-crunch/releases/download/v${version}/crunch-v${version}.tbz";
    sha256 = "0d26715a4h9r1wibnc12xy690m1kan7hrcgbb5qk8x78zsr67lnf";
  };

  propagatedBuildInputs = [ cmdliner ptime ];

  outputs = [ "lib" "bin" "out" ];

  installPhase = ''
    ${opaline}/bin/opaline -prefix $bin -libdir $lib/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = {
    homepage = "https://github.com/mirage/ocaml-crunch";
    description = "Convert a filesystem into a static OCaml module";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
