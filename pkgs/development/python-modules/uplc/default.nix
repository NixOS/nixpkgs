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
  version = "1.0.4";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "uplc";
    rev = version;
    hash = "sha256-Mio6VVgQKy1GMeHNk0DITks9Nhr3lA1t7zewu9734j4=";
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

  pythonRelaxDeps = [
    "pycardano"
    "rply"
  ];

  pythonImportsCheck = [ "uplc" ];

  meta = with lib; {
    description = "Python implementation of untyped plutus language core";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
