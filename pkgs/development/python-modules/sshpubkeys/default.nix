{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  ecdsa,
}:

buildPythonPackage rec {
  version = "3.2.0";
  format = "setuptools";
  pname = "sshpubkeys";

  src = fetchFromGitHub {
    owner = "ojarva";
    repo = "python-${pname}";
    rev = version;
    sha256 = "sha256-WDQX7pIi4sqF/W84IgmIL85cBiT+nX4pSMkJ9lvfQ00=";
  };

  propagatedBuildInputs = [
    cryptography
    ecdsa
  ];

  meta = with lib; {
    description = "OpenSSH Public Key Parser for Python";
    homepage = "https://github.com/ojarva/python-sshpubkeys";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
