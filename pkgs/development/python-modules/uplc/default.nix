{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  # Python deps
  frozenlist2,
  python-secp256k1-cardano,
  setuptools,
  poetry-core,
  frozendict,
  cbor2,
  rply,
  pycardano,
}:

buildPythonPackage rec {
  pname = "uplc";
  version = "1.0.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "uplc";
    rev = "refs/tags/${version}";
    hash = "sha256-xK2k0XLybWqyP5Qa2Oby8YBgiiswR++yVK7NPgpdSa0=";
  };

  propagatedBuildInputs = [
    setuptools
    poetry-core
    frozendict
    cbor2
    frozenlist2
    rply
    pycardano
    python-secp256k1-cardano
  ];

  pythonImportsCheck = [ "uplc" ];

  meta = with lib; {
    description = "Python implementation of untyped plutus language core";
    homepage = "https://github.com/OpShin/uplc";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
