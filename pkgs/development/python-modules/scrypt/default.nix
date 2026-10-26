{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "scrypt";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holgern";
    repo = "py-scrypt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4jVXaPD57RMe4ef1PVgZwPGAhEHL3RGlu2DSC6lGuR4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scrypt" ];

  meta = {
    description = "Python bindings for the scrypt key derivation function";
    homepage = "https://github.com/holgern/py-scrypt";
    changelog = "https://github.com/holgern/py-scrypt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
