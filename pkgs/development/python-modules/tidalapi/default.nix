{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python-dateutil
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
}:

buildPythonPackage rec {
  pname = "tidalapi";
<<<<<<< HEAD
  version = "0.7.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sIPuo1kd08Quflf7oFxoo1H56cdUDlbNTfFkn8j3jVE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

=======
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LdlTBkCOb7tXiupsNJ5lbk38syKXeADvi2IdGpW/dk8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    requests
    python-dateutil
  ];

  doCheck = false; # tests require internet access

  pythonImportsCheck = [
    "tidalapi"
  ];

  meta = with lib; {
    changelog = "https://github.com/tamland/python-tidal/releases/tag/v${version}";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = licenses.gpl3;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.rodrgz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
