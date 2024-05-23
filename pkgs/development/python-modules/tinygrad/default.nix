{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  gpuctypes,
  numpy,
  tqdm,
  hypothesis,
  librosa,
  onnx,
  pillow,
  pytest-xdist,
  pytestCheckHook,
  safetensors,
  sentencepiece,
  tiktoken,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "tinygrad";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    rev = "refs/tags/v${version}";
    hash = "sha256-QAccZ79qUbe27yUykIf22WdkxYUlOffnMlShakKfp60=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    gpuctypes
    numpy
    tqdm
  ];

  pythonImportsCheck = [ "tinygrad" ];

  nativeCheckInputs = [
    hypothesis
    librosa
    onnx
    pillow
    pytest-xdist
    pytestCheckHook
    safetensors
    sentencepiece
    tiktoken
    torch
    transformers
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Require internet access
    "test_benchmark_openpilot_model"
    "test_bn_alone"
    "test_bn_linear"
    "test_bn_mnist"
    "test_car"
    "test_chicken"
    "test_chicken_bigbatch"
    "test_conv_mnist"
    "testCopySHMtoDefault"
    "test_data_parallel_resnet"
    "test_e2e_big"
    "test_fetch_small"
    "test_huggingface_enet_safetensors"
    "test_linear_mnist"
    "test_load_convnext"
    "test_load_enet"
    "test_load_enet_alt"
    "test_load_llama2bfloat"
    "test_load_resnet"
    "test_openpilot_model"
    "test_resnet"
    "test_shufflenet"
    "test_transcribe_batch12"
    "test_transcribe_batch21"
    "test_transcribe_file1"
    "test_transcribe_file2"
    "test_transcribe_long"
    "test_transcribe_long_no_batch"
    "test_vgg7"
  ];

  disabledTestPaths = [
    "test/extra/test_lr_scheduler.py"
    "test/models/test_mnist.py"
    "test/models/test_real_world.py"
  ];

  meta = with lib; {
    description = "A simple and powerful neural network framework";
    homepage = "https://github.com/tinygrad/tinygrad";
    changelog = "https://github.com/tinygrad/tinygrad/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
