{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asn1crypto,
  cbor2,
  cryptography,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webauthn";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    tag = "v${version}";
    hash = "sha256-aZDptKJPFU6Oo4vKkIWkqkJ5ogDe5x3v7PAQRixWFe4=";
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

  meta = {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
