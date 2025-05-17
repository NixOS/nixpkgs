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
  cbor2WithoutCExtensions,
  rply,
  pycardano,
}:

buildPythonPackage rec {
  pname = "uplc";
  version = "1.0.10";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "uplc";
    tag = version;
    hash = "sha256-Owo4W4jChrdYnz11BbWQdm2SiwFwOJlqjYutuRyjpxs=";
  };

  propagatedBuildInputs = [
    setuptools
    poetry-core
    frozendict
    cbor2WithoutCExtensions
    frozenlist2
    rply
    pycardano
    python-secp256k1-cardano
  ];

  # Use cbor2 without C extensions
  postPatch = ''
    substituteInPlace uplc/ast.py --replace-fail 'from _cbor2' 'from cbor2'
  '';

  pythonImportsCheck = [ "uplc" ];

  meta = with lib; {
    description = "Python implementation of untyped plutus language core";
    homepage = "https://github.com/OpShin/uplc";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
