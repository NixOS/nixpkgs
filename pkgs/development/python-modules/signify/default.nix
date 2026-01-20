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

buildPythonPackage rec {
  pname = "signify";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "signify";
    tag = "v${version}";
    hash = "sha256-ICmBzIbkynxRNojNQrQZoydMyFd6j3F1BLWN8VeB5dE=";
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
    changelog = "https://github.com/ralphje/signify/blob/refs/tags/${src.tag}/docs/changelog.rst";
    description = "Library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
