{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  numpy,
  torch,
  bitsandbytes,
}:

buildPythonPackage rec {
  pname = "unsloth";
  version = "2025-02-v2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unslothai";
    repo = "unsloth";
    tag = version;
    hash = "sha256-Z6plMoaay5SU2AlU68T7F7C9i8Zr12C+rNA0BHH1dQ0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    numpy
    torch
    bitsandbytes
  ];

  # The source repository contains no test
  doCheck = false;

  # Importing requires a GPU, else the following error is raised:
  # NotImplementedError: Unsloth: No NVIDIA GPU found? Unsloth currently only supports GPUs!
  # pythonImportsCheck = [
  #   "unsloth"
  # ];

  meta = {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory";
    homepage = "https://github.com/unslothai/unsloth";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
