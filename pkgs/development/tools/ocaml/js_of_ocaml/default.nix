{ buildDunePackage, js_of_ocaml-compiler
, ppxlib, uchar
}:

buildDunePackage {
  pname = "js_of_ocaml";

  inherit (js_of_ocaml-compiler) version src;
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ ppxlib ];

  propagatedBuildInputs = [ js_of_ocaml-compiler uchar ];

  meta = builtins.removeAttrs js_of_ocaml-compiler.meta [ "mainProgram" ];
}
