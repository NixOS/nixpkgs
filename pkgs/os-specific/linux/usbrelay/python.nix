{ buildPythonPackage, usbrelay }:

<<<<<<< HEAD
buildPythonPackage {
=======
buildPythonPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "usbrelay_py";
  inherit (usbrelay) version src;

  preConfigure = ''
    cd usbrelay_py
  '';

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  inherit (usbrelay) meta;
}
