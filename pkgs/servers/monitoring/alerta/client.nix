{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "alerta";
  version = "8.5.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-O13Ic2iHjNF/llp6vdaAiiWExcTBPsz46GAWY3oGDY8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    six click requests requests-hawk pytz tabulate
  ];

  doCheck = false;

  disabled = python3.pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
