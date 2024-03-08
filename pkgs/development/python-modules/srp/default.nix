{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LbRTvc4mue6tNnp7V4MHTvgOhIK/MMAUCnuJg2oFRwc=";
  };

  propagatedBuildInputs = [
    six
  ];

  # Tests ends up with libssl.so cannot load shared
  doCheck = false;

  pythonImportsCheck = [
    "srp"
  ];

  meta = with lib; {
    description = "Implementation of the Secure Remote Password protocol (SRP)";
    longDescription = ''
     This package provides an implementation of the Secure Remote Password protocol (SRP).
     SRP is a cryptographically strong authentication protocol for password-based, mutual authentication over an insecure network connection.
    '';
    homepage = "https://github.com/cocagne/pysrp";
    license = licenses.mit;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
