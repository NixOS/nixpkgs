{ stdenv, buildPythonPackage, fetchPypi, six, lib }:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5b8ed6dc7d3ae2845a16590ef37763bbf15d6049848b85a8c96dfb8a83c984a";
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
