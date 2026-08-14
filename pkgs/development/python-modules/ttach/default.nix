{
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  torch,
  buildPythonPackage,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttach";
  version = "0.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qubvel";
    repo = "ttach";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R6QO+9hv0eI7dZW5iJf096+LU1q+vnmOpveurgZemPc=";
  };

  build-system = [ setuptools ];

  dependencies = [ torch ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "ttach" ];

  meta = {
    description = "Image Test Time Augmentation with PyTorch";
    homepage = "https://github.com/qubvel/ttach";
    license = lib.licenses.mit;
  };
})
