<<<<<<< HEAD
{ lib, fetchurl, yojson, csexp, findlib, buildDunePackage, merlin-lib, merlin, result }:
=======
{ lib, fetchurl, yojson, csexp, findlib, buildDunePackage, merlin-lib, merlin }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage rec {
  pname = "dot-merlin-reader";

  duneVersion = "3";

  inherit (merlin) version src;

  minimalOCamlVersion = "4.06";

  buildInputs = [ findlib ]
  ++ (if lib.versionAtLeast version "4.7-414"
  then [ merlin-lib ]
<<<<<<< HEAD
  else [ yojson csexp result ]);
=======
  else [ yojson csexp ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Reads config files for merlin";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.hongchangwu ];
  };
}
