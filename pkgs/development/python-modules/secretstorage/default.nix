{ lib, fetchPypi, buildPythonPackage, pythonOlder, cryptography, jeepney, pygobject3 }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "3.1.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    sha256 = "12vxzradibfmznssh7x2zd7qym2hl7wn34fn2yn58pnx6sykrai9";
  };

  propagatedBuildInputs = [
    cryptography
    jeepney
    pygobject3
  ];

  # Needs a D-Bus Sesison
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/mitya57/secretstorage;
    description = "Python bindings to FreeDesktop.org Secret Service API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teto ];
  };
}
