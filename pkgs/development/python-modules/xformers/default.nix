{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  ninja,
  which,
  # runtime dependencies
  numpy,
  torch,
  # check dependencies
  pytestCheckHook,
  pytest-cov,
  # , pytest-mpi
  pytest-timeout,
  # , pytorch-image-models
  hydra-core,
  fairscale,
  scipy,
  cmake,
  openai-triton,
  networkx,
  #, apex
  einops,
  transformers,
  timm,
#, flash-attn
}:
let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  version = "0.0.23.post1";
in
buildPythonPackage {
  pname = "xformers";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    rev = "refs/tags/v${version}";
    hash = "sha256-AJXow8MmX4GxtEE2jJJ/ZIBr+3i+uS4cA6vofb390rY=";
    fetchSubmodules = true;
  };

  patches = [ ./0001-fix-allow-building-without-git.patch ];

  preBuild =
    ''
      cat << EOF > ./xformers/version.py
      # noqa: C801
      __version__ = "${version}"
      EOF
    ''
    + lib.optionalString cudaSupport ''
      export CUDA_HOME=${cudaPackages.cuda_nvcc.bin}
      export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    ''
    # NOTE: While normally the CUDA setup hooks take care of all the NVCC flags which make sure we use an appropriate
    # version of GCC, we need to manually set them here because it's not CMake building the project -- it's a Python
    # process which doesn't have access to our environment variables. As such, we need to manually add the contents
    # of NVCC_PREPEND_FLAGS, which is normally prepended to the NVCC_FLAGS by NVCC itself, to NVCC_FLAGS.
    + lib.optionalString cudaSupport ''
      export NVCC_FLAGS="$NVCC_PREPEND_FLAGS $NVCC_FLAGS"
    '';

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      # flash-attn build
      cuda_cudart # cuda_runtime_api.h
      libcusparse.dev # cusparse.h
      cuda_cccl.dev # nv/target
      libcublas.dev # cublas_v2.h
      libcusolver.dev # cusolverDn.h
      libcurand.dev # curand_kernel.h
    ]
  );

  nativeBuildInputs = [
    ninja
    which
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  propagatedBuildInputs = [
    numpy
    torch
  ];

  pythonImportsCheck = [ "xformers" ];

  # Has broken 0.03 version:
  # https://github.com/NixOS/nixpkgs/pull/285495#issuecomment-1920730720
  passthru.skipBulkUpdate = true;

  dontUseCmakeConfigure = true;

  # see commented out missing packages
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-timeout
    hydra-core
    fairscale
    scipy
    cmake
    networkx
    openai-triton
    # apex
    einops
    transformers
    timm
    # flash-attn
  ];

  meta = with lib; {
    description = "XFormers: A collection of composable Transformer building blocks";
    homepage = "https://github.com/facebookresearch/xformers";
    changelog = "https://github.com/facebookresearch/xformers/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ happysalada ];
  };
}
