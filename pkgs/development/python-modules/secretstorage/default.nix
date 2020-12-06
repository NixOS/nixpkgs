{ lib, fetchPypi, buildPythonPackage, pythonOlder, cryptography, jeepney }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "3.3.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    sha256 = "1aj669d5s8pmr6y2d286fxd13apnxzw0ivd1dr6xdni9i3rdxkrh";
  };

  propagatedBuildInputs = [
    cryptography
    jeepney
  ];

  # Needs a D-Bus Sesison
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mitya57/secretstorage";
    description = "Python bindings to FreeDesktop.org Secret Service API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teto ];
  };
}
