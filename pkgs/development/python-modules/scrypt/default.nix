{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holgern";
    repo = "py-scrypt";
    tag = "v${version}";
    hash = "sha256-r5tXRq4VFieqw3Plx6W5imDIeGIldW1BREdm6/Kav3M=";
  };

  build-system = [ setuptools ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scrypt" ];

  meta = {
    description = "Python bindings for the scrypt key derivation function";
    homepage = "https://github.com/holgern/py-scrypt";
    changelog = "https://github.com/holgern/py-scrypt/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
