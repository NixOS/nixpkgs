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
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
