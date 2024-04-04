{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonRelaxDepsHook
# Python deps
, frozenlist2
, python-secp256k1-cardano
, setuptools
, poetry-core
, frozendict
, cbor2
, rply
, pycardano
}:

buildPythonPackage rec {
  pname = "uplc";
  version = "0.6.9";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "uplc";
    rev = version;
    hash = "sha256-djJMNXijMVzMVzw8NZSe3YFRGyAPqdvr0P374Za5XkU=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

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

  pythonRelaxDeps = [ "pycardano" "rply" ];

  pythonImportsCheck = [ "uplc" ];

  meta = with lib; {
    description = "Python implementation of untyped plutus language core";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
