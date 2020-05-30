{ stdenv, buildPythonPackage, fetchPypi, six, lib }:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c943b7181322a2bdd50d20e1244536c404916e546131dc1fae10a7cb99a013e9";
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
