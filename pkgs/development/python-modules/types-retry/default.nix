{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-retry";
<<<<<<< HEAD
  version = "0.9.9.4";
=======
  version = "0.9.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-5HMdxoS1a4ddl0ZFmtZl07woGla1MKzfHJdzAWd5mUE=";
=======
    hash = "sha256-G3oKBK3xLyEjfnaDNXSpqPdV+IiJwiatmdbjv6W248g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "retry-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
