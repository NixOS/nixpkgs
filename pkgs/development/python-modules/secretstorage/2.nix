{ lib, fetchPypi, buildPythonPackage, cryptography, dbus-python }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "2.3.1";

  src = fetchPypi {
    pname = "SecretStorage";
    inherit version;
    sha256 = "1di9gx4m27brs6ar774m64s017iz742mnmw39kvfc8skfs3mrxis";
  };

  propagatedBuildInputs = [ cryptography dbus-python ];

  # Needs a D-Bus Sesison
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/mitya57/secretstorage;
    description = "Python bindings to FreeDesktop.org Secret Service API";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
  };
}
