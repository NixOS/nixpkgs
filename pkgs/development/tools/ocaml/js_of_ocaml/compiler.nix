{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  cmdliner,
  yojson,
  ppxlib,
  findlib,
  menhir,
  menhirLib,
  sedlex,
  version ? if lib.versionAtLeast ocaml.version "4.11" then "5.9.1" else "5.8.2",
}:

buildDunePackage {
  pname = "js_of_ocaml-compiler";
  inherit version;
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
    hash =
      {
        "5.9.1" = "sha256-aMlcYIcdjpyaVMgvNeLtUEE7y0QPIg0LNRayoe4ccwc=";
        "5.8.2" = "sha256-ciAZS9L5sU2VgVOlogZ1A1nXtJ3hL+iNdFDThc7L8Eo=";
      }
      ."${version}";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [
    cmdliner
    ppxlib
  ];

  propagatedBuildInputs = [
    menhirLib
    yojson
    findlib
    sedlex
  ];

  meta = with lib; {
    description = "Compiler from OCaml bytecode to Javascript";
    homepage = "https://ocsigen.org/js_of_ocaml/";
    license = licenses.gpl2;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "js_of_ocaml";
  };
}
