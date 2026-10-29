{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  datasets,
  einops,
  fsspec,
  pillow,
  tensorboard,
  tokenizers,
  tomli,
  torch,
  torchdata,
  transformers,
  tyro,

  # tests
  pytestCheckHook,
  tomli-w,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchtitan";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torchtitan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YXbbqNjmPBIFDRbvagHRIy5ph1pZmSerUxlqaF6f4cY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    datasets
    einops
    fsspec
    pillow
    tensorboard
    tokenizers
    tomli
    torch
    torchdata
    tyro
  ];

  pythonImportsCheck = [ "torchtitan" ];

  nativeCheckInputs = [
    pytestCheckHook
    tomli-w
    transformers
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Require internet access
    "test_list_files"
  ];

  disabledTestPaths = [
    # Require internet access
    "tests/unit_tests/test_tokenizer.py"
  ];

  meta = {
    description = "PyTorch native platform for training generative AI models";
    homepage = "https://github.com/pytorch/torchtitan";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
