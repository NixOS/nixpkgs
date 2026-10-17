{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasn1,
  pyasn1-modules,
  cbor2,
  cryptography,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "webauthn";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rT/B95ILb2cI/HH01IC5b4319zdKnrf4ZLUIpAeC3fM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyasn1
    pyasn1-modules
    cbor2
    cryptography
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webauthn" ];

  meta = {
    description = "Implementation of the WebAuthn API";
    homepage = "https://github.com/duo-labs/py_webauthn";
    changelog = "https://github.com/duo-labs/py_webauthn/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
