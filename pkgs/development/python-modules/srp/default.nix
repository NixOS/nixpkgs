{ buildPythonPackage, fetchPypi, six, lib }:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2e3fed4e5cbfd6b481edc9cdd51a8c39a609eae117210218556004bdc9016b2";
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
