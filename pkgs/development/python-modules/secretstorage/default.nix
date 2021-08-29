{ lib, fetchPypi, buildPythonPackage, pythonOlder, cryptography, jeepney }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "3.3.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    sha256 = "15ginv4gzxrx77n7517xnvf2jcpqc6ran12s951hc85zlr8nqrpx";
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
