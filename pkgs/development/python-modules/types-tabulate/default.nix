{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-tabulate";
<<<<<<< HEAD
  version = "0.9.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GXZR+dZGcZPNFm2FABFqbTom8qTrLbCTvJU17hwL5V4=";
=======
  version = "0.9.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HdQyKjoUbpBzFpx0J4uPFKWOuZBcqdsNJYjfQI8nysk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "tabulate-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
