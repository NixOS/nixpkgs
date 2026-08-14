{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  symlinkJoin,

  # build-system
  setuptools,

  # nativeBuildInputs
  autoAddDriverRunpath,

  # dependencies
  torch,

  # tests
  nvidia-ml-py,
  pytestCheckHook,
  torch-memory-saver,
}:
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torch-memory-saver";
  version = "0.0.9.post1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fzyzcjy";
    repo = "torch_memory_saver";
    # branch 0.0.9.post1
    rev = "0c88c358824bd304daeec34ac792a55e3fa2c1f2";
    hash = "sha256-xYkHhfCj3cOzAK5pmWCDfRw5FL8BzBkeUaDnqVlmSiY=";
  };

  # fix CUDA library_dirs
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail lib64 lib
  '';

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  env = {
    TMS_CUDA_MAJOR = cudaPackages.cudaMajorVersion;
    CUDA_HOME = symlinkJoin {
      name = "cudatoolkit-joined";
      paths = [
        cudaPackages.cuda_nvcc # crt/host_defines.h
        cudaPackages.cuda_cudart # cuda_runtime_api.h
      ];
    };
  };

  dependencies = [
    nvidia-ml-py
    torch
  ];

  pythonImportsCheck = [ "torch_memory_saver" ];

  preCheck = ''
    rm -r torch_memory_saver
  '';

  # requires GPU
  doCheck = false;
  nativeCheckInputs = [
    # propagated from torch
    nvidia-ml-py
    pytestCheckHook
  ];

  passthru.gpuCheck = torch-memory-saver.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Library that allows tensor memory to be temporarily released and resumed later";
    homepage = "https://github.com/fzyzcjy/torch_memory_saver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    # TODO: ROCm
    broken = !torch.cudaSupport;
  };
})
