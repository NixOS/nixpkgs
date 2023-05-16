{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pname = "base16-shell-preview";
  version = "1.0.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version;
    pname = "${lib.replaceStrings ["-"] ["_"] pname}";
    hash = "sha256-retnbxjdjo+NeA1B0+jpM9kToAX/Rh0ze0yNF9AfDiU=";
  };

  # If enabled, it will attempt to run '__init__.py, failing by trying to write
  # at "/homeless-shelter" as HOME
  doCheck = false;

  meta = {
    homepage = "https://github.com/nvllsvm/base16-shell-preview";
    description = "Browse and preview Base16 Shell themes in your terminal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
