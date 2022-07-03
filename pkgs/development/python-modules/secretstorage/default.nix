{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, jeepney
, pythonOlder
}:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "3.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    hash = "sha256-Co65ZFsyCIHCIugnwm9M/PVTY+izdKAhmB74hmV6kS8=";
  };

  propagatedBuildInputs = [
    cryptography
    jeepney
  ];

  # Needs a D-Bus session
  doCheck = false;

  pythonImportsCheck = [
    "secretstorage"
  ];

  meta = with lib; {
    description = "Python bindings to FreeDesktop.org Secret Service API";
    homepage = "https://github.com/mitya57/secretstorage";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teto ];
  };
}
