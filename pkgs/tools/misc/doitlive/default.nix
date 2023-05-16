<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.3.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "03qrs032x206xrl0x3z0fpvxgjivzz9rkmb11bqlk1id10707cac";
  };

  propagatedBuildInputs = with python3Packages; [ click click-completion click-didyoumean ];

  # disable tests (too many failures)
  doCheck = false;

  meta = with lib; {
    description = "Tool for live presentations in the terminal";
    homepage = "https://pypi.python.org/pypi/doitlive";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
