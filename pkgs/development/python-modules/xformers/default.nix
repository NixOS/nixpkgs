{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  which,
  setuptools,
  # runtime dependencies
  numpy,
  torch,
  # check dependencies
  pytestCheckHook,
  pytest-cov-stub,
  # , pytest-mpi
  pytest-timeout,
  # , pytorch-image-models
  hydra-core,
  fairscale,
  scipy,
  cmake,
  ninja,
  triton,
  networkx,
  #, apex
  einops,
  transformers,
  timm,
  #, flash-attn
  openmp,
}:
let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;

  # version 0.0.32.post2 was confirmed to break CUDA.
  # Remove this note once the latest published revision "just works".
  version = "0.0.30";
in
buildPythonPackage {
  pname = "xformers";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ozaw9z8qnGpZ28LQNtwmKeVnrn7KDWNeJKtT6g6Q/W0=";
  };

  patches = [ ./0001-fix-allow-building-without-git.patch ];

  build-system = [ setuptools ];

  preBuild = ''
    cat << EOF > ./xformers/version.py
    # noqa: C801
    __version__ = "${version}"
    EOF

    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  env = lib.attrsets.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
  };

  stdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  buildInputs =
    lib.optional stdenv.hostPlatform.isDarwin openmp
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        # flash-attn build
        cuda_cudart # cuda_runtime_api.h
        libcusparse # cusparse.h
        cuda_cccl # nv/target
        libcublas # cublas_v2.h
        libcusolver # cusolverDn.h
        libcurand # curand_kernel.h
      ]
    );

  nativeBuildInputs = [
    ninja
    which
  ]
  ++ lib.optionals cudaSupport (with cudaPackages; [ cuda_nvcc ])
  ++ lib.optional stdenv.hostPlatform.isDarwin openmp.dev;

  dependencies = [
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
    pytest-cov-stub
    pytest-timeout
    hydra-core
    fairscale
    scipy
    cmake
    networkx
    triton
    # apex
    einops
    transformers
    timm
    # flash-attn
  ];

  meta = {
    description = "Collection of composable Transformer building blocks";
    homepage = "https://github.com/facebookresearch/xformers";
    changelog = "https://github.com/facebookresearch/xformers/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
