{ lib, fetchPypi, buildPythonPackage, pythonOlder, cryptography, jeepney }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "3.1.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    sha256 = "14lznnn916ddn6yrd3w2nr2zq49zc8hw53yjz1k9yhd492p9gir0";
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
