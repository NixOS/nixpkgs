{ buildDunePackage, js_of_ocaml-compiler
, ppxlib
, js_of_ocaml
}:

buildDunePackage {
  pname = "js_of_ocaml-ppx";

  inherit (js_of_ocaml-compiler) version src;
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ js_of_ocaml ];
  propagatedBuildInputs = [ ppxlib ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
