{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  git,
  which,

  # build-system
  setuptools,

  # dependencies
  psutil,
  torch,

  cudaPackages,
}:

buildPythonPackage rec {
  pname = "flash-attention";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "flash-attention";
    rev = "refs/tags/v${version}";
    hash = "sha256-dsD8/4RsWFvB5eQo8BG4uN3s7+7v8qPdBWTQrqMsVAc=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    git
    which
  ];

  buildInputs = [
    cudaPackages.cuda_nvcc
  ];

  build-system = [ setuptools ];

  dependencies = [
    psutil
    torch
  ];

  env.CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";

  pythonImportsCheck = [
    "flash_attention"
  ];

  meta = {
    description = "Fast and memory-efficient exact attention";
    homepage = "https://github.com/vllm-project/flash-attention";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
