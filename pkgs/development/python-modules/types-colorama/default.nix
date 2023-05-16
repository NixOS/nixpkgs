{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
<<<<<<< HEAD
  version = "0.4.15.12";
=======
  version = "0.4.15.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-+9/F2dJNhcM70FT74zrcbOxE7tsZz7ur+7tX3CV65Lg=";
=======
    hash = "sha256-qUIesk2c/FhIgNwdM7f9QGoUInwfmfUMWrkmXgTQdjg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
