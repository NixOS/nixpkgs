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
  cbor2,
  rply,
  pycardano,
  uplc,
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
    cbor2
    frozenlist2
    rply
    pycardano
    python-secp256k1-cardano
  ];

  # Support cbor2 without C extensions
  postPatch = lib.optionalString (!cbor2.withCExtensions) ''
    substituteInPlace uplc/ast.py --replace-fail 'from _cbor2' 'from cbor2'
  '';

  pythonImportsCheck = [ "uplc" ];

  passthru.tests.withoutCExtensions = uplc.override {
    cbor2 = cbor2WithoutCExtensions;
  };

  meta = with lib; {
    description = "Python implementation of untyped plutus language core";
    homepage = "https://github.com/OpShin/uplc";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
    mainProgram = "opshin";
  };
}
