{ lib
, buildPythonPackage
, fetchFromGitHub
, paramiko
, pythonOlder
}:

buildPythonPackage rec {
  pname = "spur";
  version = "0.3.22";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "spur.py";
    rev = version;
    hash = "sha256-YlwezAE7V4ykFsp+bJ2nYRp6HG4I9Bk7Lhq6f1Inn0s=";
  };

  propagatedBuildInputs = [
    paramiko
  ];

  # Tests require a running SSH server
  doCheck = false;

  pythonImportsCheck = [
    "spur"
  ];

  meta = with lib; {
    description = "Python module to run commands and manipulate files locally or over SSH";
    homepage = "https://github.com/mwilliamson/spur.py";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
