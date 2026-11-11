{
  lib,
  asn1crypto,
  buildPythonPackage,
  certvalidator,
  fetchFromGitHub,
  mscerts,
  oscrypto,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "signify";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "signify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gE0j0P4BXVwntfvn7G3rHB0pnO/0RWkUDp+XWfRixLY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    certvalidator
    mscerts
    oscrypto
    typing-extensions
  ];

  pythonImportsCheck = [ "signify" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/ralphje/signify/blob/refs/tags/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
})
