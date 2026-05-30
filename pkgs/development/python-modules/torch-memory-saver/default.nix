{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  symlinkJoin,

  setuptools,
  torch,
}:
buildPythonPackage (finalAttrs: {
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

  patches = [
    ./cuda-library-dirs.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [ "torch_memory_saver" ];

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

  meta = {
    description = "Library that allows tensor memory to be temporarily released and resumed later";
    homepage = "https://github.com/fzyzcjy/torch_memory_saver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
