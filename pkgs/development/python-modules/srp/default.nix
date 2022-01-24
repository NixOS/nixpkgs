{ buildPythonPackage, fetchPypi, six, lib }:

buildPythonPackage rec {
  pname = "srp";
  version = "1.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1582317ccd383dc39d54f223424c588254d73d1cfb2c5c24d945e018ec9516bb";
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
