{ lib, buildPythonPackage, fetchFromGitHub
, cryptography
, ecdsa
}:

buildPythonPackage rec {
  version = "3.3.1";
  format = "setuptools";
  pname = "sshpubkeys";

  src = fetchFromGitHub {
    owner = "ojarva";
    repo = "python-${pname}";
    rev = version;
    sha256 = "1qsixmqg97kyvg1naw76blq4314vaw4hl5f9wi0v111mcmdia1r4";
  };

  propagatedBuildInputs = [ cryptography ecdsa ];

  meta = with lib; {
    description = "OpenSSH Public Key Parser for Python";
    homepage = "https://github.com/ojarva/python-sshpubkeys";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
