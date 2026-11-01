{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  torch,

  # tests
  expecttest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-remat";
  version = "0.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "remat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bUonwvGPaCJ29YxokoCTn8zSxcAxmxyQMeFtoAhC99s=";
  };

  # The version was not bumped in pyproject.toml for the v0.2.2 tag
  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [ "torch_remat" ];

  nativeCheckInputs = [
    expecttest
    pytestCheckHook
  ];

  disabledTests = [
    # AttributeError: module 'torch._C' has no attribute '_cuda_memorySnapshot'
    "test_fetch_is_memoized_until_refresh_or_clear"
  ];

  meta = {
    description = "Explicit activation rematerialization helpers for PyTorch";
    homepage = "https://github.com/meta-pytorch/remat";
    changelog = "https://github.com/meta-pytorch/remat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
