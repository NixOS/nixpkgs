{ lib, buildDunePackage, js_of_ocaml-compiler, ppxlib }:

buildDunePackage {
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "js_of_ocaml-toplevel";
  inherit (js_of_ocaml-compiler) src version;
  buildInputs = [ ppxlib ];
  propagatedBuildInputs = [ js_of_ocaml-compiler ];
  meta = js_of_ocaml-compiler.meta // {
    mainProgram = "jsoo_mktop";
  };
}
