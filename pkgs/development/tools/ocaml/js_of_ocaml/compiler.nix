{ lib, fetchurl, buildDunePackage
, cmdliner, yojson, ppxlib, findlib
<<<<<<< HEAD
, menhir, menhirLib, sedlex
=======
, menhir, menhirLib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "js_of_ocaml-compiler";
<<<<<<< HEAD
  version = "5.4.0";
=======
  version = "4.1.0";
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/releases/download/${version}/js_of_ocaml-${version}.tbz";
<<<<<<< HEAD
    hash = "sha256-8SFd4TOGf+/bFuJ5iiJe4ERkaaV0Yq8N7r3SLSqNO5Q=";
=======
    sha256 = "sha256-kXk/KaWvPeq6P301zqsR5znP4KXMMFVvYgFGGm1CNu8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ppxlib ];

<<<<<<< HEAD
  propagatedBuildInputs = [ menhirLib yojson findlib sedlex ];
=======
  configurePlatforms = [];
  propagatedBuildInputs = [ menhirLib yojson findlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Compiler from OCaml bytecode to Javascript";
    homepage = "https://ocsigen.org/js_of_ocaml/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "js_of_ocaml";
  };
}
