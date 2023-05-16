{ lib,
  python3,
<<<<<<< HEAD
  fetchPypi,
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gay";
  version = "1.2.9";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-x+RVVgQvJwV5j7DLYS7AnXb4OMJ4v+l0awUuonQIgzY=";
  };

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/gay";
    description = "Colour your text / terminal to be more gay";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres CodeLongAndProsper90 ];
  };
}
