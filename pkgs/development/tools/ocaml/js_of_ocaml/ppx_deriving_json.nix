{ buildDunePackage, js_of_ocaml-compiler
, js_of_ocaml, ppxlib
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx_deriving_json";

  inherit (js_of_ocaml-compiler) version src;
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [ js_of_ocaml ppxlib ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
