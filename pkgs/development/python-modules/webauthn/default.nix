{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asn1crypto,
  cbor2,
  cryptography,
  pythonOlder,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webauthn";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "refs/tags/v${version}";
    hash = "sha256-NBCR5GwmXA6COP9NOYnoD3l1vuOpym/kyNawd8FstLc=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    asn1crypto
    cbor2
    cryptography
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webauthn" ];

  disabledTests = [
    # TypeError: X509StoreContextError.__init__() missing 1 required...
    #"test_throws_on_bad_root_cert"
  ];

  meta = with lib; {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
