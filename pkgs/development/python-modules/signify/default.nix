{
  lib,
  asn1crypto,
  buildPythonPackage,
  certvalidator,
  fetchFromGitHub,
  mscerts,
  oscrypto,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "signify";
    tag = "v${version}";
    hash = "sha256-yQCb7vNbz+ZGftqlEUUh6UUuxwv5+zhvBJmUn1eNgqM=";
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
    description = "library that verifies PE Authenticode-signed binaries";
    homepage = "https://github.com/ralphje/signify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
