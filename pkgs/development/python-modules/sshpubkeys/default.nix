{ lib, buildPythonPackage, fetchFromGitHub
, cryptography
, ecdsa
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "sshpubkeys";

  src = fetchFromGitHub {
    owner = "ojarva";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "1h4gwmcfn84kkqh83km1vfz8sc5kr2g4gzgzmr8gz704jmqiv7nq";
  };

  propagatedBuildInputs = [ cryptography ecdsa ];

  meta = with lib; {
    description = "OpenSSH Public Key Parser for Python";
    homepage = "https://github.com/ojarva/python-sshpubkeys";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
