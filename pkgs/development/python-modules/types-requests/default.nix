{ lib
, buildPythonPackage
, fetchPypi
, types-urllib3
}:

buildPythonPackage rec {
  pname = "types-requests";
<<<<<<< HEAD
  version = "2.31.0.2";
=======
  version = "2.30.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-aqP3+vDqUtcouxjAoNFSLZv9jHLSb/b2G/w9BqQRz0A=";
=======
    hash = "sha256-3seBBUMkpwumRDCunmLn6cjkYYwYWlyz+HpnOCUbWjE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    types-urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "requests-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
