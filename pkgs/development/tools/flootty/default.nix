<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "Flootty";
  version = "3.2.2";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "0gfl143ly81pmmrcml91yr0ypvwrs5q4s1sfdc0l2qkqpy233ih7";
  };

  meta = with lib; {
    description = "A collaborative terminal. In practice, it's similar to a shared screen or tmux session";
    homepage = "https://floobits.com/help/flootty";
    license = licenses.asl20;
    maintainers = with maintainers; [ sellout ];
  };
}
