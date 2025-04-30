{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  bitsandbytes,
  numpy,
  packaging,
  torch,
  unsloth-zoo,
  xformers,
  tyro,
  transformers,
  datasets,
  sentencepiece,
  tqdm,
  accelerate,
  trl,
  peft,
  protobuf,
  huggingface-hub,
  hf-transfer,
  diffusers,
  torchvision,
}:

buildPythonPackage rec {
  pname = "unsloth";
  version = "2025.4.1";
  pyproject = true;

  # Tags on the GitHub repo don't match
  src = fetchPypi {
    pname = "unsloth";
    inherit version;
    hash = "sha256-9LtDGfdWH7R3U/xi+aK3V4zA+vs83S6Cp0F2NQKvSdY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bitsandbytes
    numpy
    packaging
    torch
    unsloth-zoo
    xformers
    tyro
    transformers
    datasets
    sentencepiece
    tqdm
    accelerate
    trl
    peft
    protobuf
    huggingface-hub
    hf-transfer
    diffusers
    torchvision
  ];

  # pyproject.toml requires an obsolete version of protobuf,
  # but it is not used.
  # Upstream issue: https://github.com/unslothai/unsloth-zoo/pull/68
  pythonRelaxDeps = [
    "protobuf"
  ];

  # The source repository contains no test
  doCheck = false;

  # Importing requires a GPU, else the following error is raised:
  # NotImplementedError: Unsloth: No NVIDIA GPU found? Unsloth currently only supports GPUs!
  dontUsePythonImportsCheck = true;

  meta = {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory";
    homepage = "https://github.com/unslothai/unsloth";
    changelog = "https://github.com/unslothai/unsloth/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
