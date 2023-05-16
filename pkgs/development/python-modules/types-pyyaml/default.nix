{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
<<<<<<< HEAD
  version = "6.0.12.11";
=======
  version = "6.0.12.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    pname = "types-PyYAML";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-fTQLGcoozd/bpDjuY4zUCEveIT5QGjl4c4VD4nCUd1s=";
=======
    hash = "sha256-xRsb1tmd3wqiiEp6MogQ6/cKQmLCkhldP0+aAAX57rY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "yaml-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
