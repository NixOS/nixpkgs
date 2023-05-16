{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-psutil";
<<<<<<< HEAD
  version = "5.9.5.16";
=======
  version = "5.9.5.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-TpshnvtiXT0E9r8QaTT4fKtJqkGpSwo7MIlAP0enkig=";
=======
    hash = "sha256-xsfmtBtvfruHr9VlDfNgdR0Ois8NJ2t6xk0A9Bm+uSI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "psutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
