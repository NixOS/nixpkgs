{ buildPythonPackage, fetchPypi, six, lib }:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SOZT6MP1kJCbpAcwbrLoRgosfR+GxWvOWc9Cr1T/XSo=";
  };

  propagatedBuildInputs = [ six ];

  # Tests ends up with libssl.so cannot load shared
  doCheck = false;

  meta = with lib; {
    longDescription = ''
     This package provides an implementation of the Secure Remote Password protocol (SRP).
     SRP is a cryptographically strong authentication protocol for password-based, mutual authentication over an insecure network connection.
    '';
    homepage = "https://github.com/cocagne/pysrp";
    license = licenses.mit;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
