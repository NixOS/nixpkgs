{
  lib,
  applyPatches,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  cmake,
  cudaPackages,
  nlohmann_json,
  numactl,
  scikit-build-core,
  torch,
}:
let
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "57e3cfb47a2d9e0d46eb6335c3dc411498efa198";
    hash = "sha256-9CrPhjVNnexyw92Iov9Ky9TMfV770w8RkiUPDLjUm3s=";
  };
  triton = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    tag = "v3.6.0";
    hash = "sha256-JFSpQn+WsNnh7CAPlcpOcUp0nyKXNbJEANdXqmkt4Tc=";
  };
  flashinfer = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    rev = "bc29697ba20b7e6bdb728ded98f04788e16ee021";
    hash = "sha256-3C9ykrXvAnbHu0DeUkK9kOXatNRKLhhZukxPbilPNw8=";
  };
  flash-attn = fetchFromGitHub {
    owner = "sgl-project";
    repo = "sgl-flash-attn";
    rev = "bcf72ccc6816b36a5fae2c5a3c027604629785e0";
    hash = "sha256-aiXmM/PD7MP9o+iskwFmQ+10CqEybuUDDcmFfQ0M2mU=";
  };
  mscclpp = applyPatches {
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "mscclpp";
      rev = "51eca89d20f0cfb3764ccd764338d7b22cd486a6";
      hash = "sha256-k0C4W5EV5GMbF/rNebHyRar9y7JqCBZgL8ocNkwE6/E=";
    };
    patches = [
      ./mscclpp-nlohmann_json.patch
    ];
  };
  flashmla = fetchFromGitHub {
    owner = "sgl-project";
    repo = "FlashMLA";
    rev = "abb54777d4e08c8054c238f59889b52d4e9f0896";
    # cutlass/util/command_line.h
    fetchSubmodules = true;
    hash = "sha256-EQ7Wtb15IKU9Ay8FLOs6IAfM8zbnngJB4CJts8MQGQ0=";
  };
in
buildPythonPackage.override { stdenv = torch.stdenv; } (finalAttrs: {
  pname = "sglang-kernel";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sgl-project";
    repo = "sglang";
    # https://github.com/sgl-project/whl/releases/tag/v0.4.3
    rev = "156d1af23a4fa80809ab423bc1042d732ef6f95f";
    hash = "sha256-uE6R8kKdVBucqPULiD3jiZjQU2MptzE+1bV3VJtxgdI=";
  };

  sourceRoot = "${finalAttrs.src.name}/sgl-kernel";

  patches = [
    # version number
    (fetchpatch2 {
      url = "https://github.com/sgl-project/sglang/commit/0753182b50f041be7f8c6e7f5c01ff79e655ecfb.patch?full_index=1";
      stripLen = 1;
      hash = "sha256-n1iMMLvSLuwcFA7wnZ9ZN3vVnCfD2V3kDl/IkkPMiUk=";
    })

    ./no-repo-fmt.patch
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcurand # curand.h
    cudaPackages.libcusolver # cusolver_common.h
    cudaPackages.libcusparse # cusparse.h
    nlohmann_json
    numactl
    torch
  ];

  build-system = [
    cmake
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeFeature "CUDA_VERSION" cudaPackages.cudaMajorMinorVersion)

    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-CUTLASS" "${cutlass}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-TRITON" "${triton}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-FLASHINFER" "${flashinfer}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-FLASH-ATTENTION" "${flash-attn}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-MSCCLPP" "${mscclpp}")
    (lib.cmakeBool "MSCCLPP_BUILD_PYTHON_BINDINGS" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_REPO-FLASHMLA" "${flashmla}")
  ];

  # cannot find -lcuda: No such file or directory
  env.NIX_LDFLAGS = "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs";

  meta = {
    description = "Kernel Library for SGLang";
    homepage = "https://github.com/sgl-project/sglang/tree/main/sgl-kernel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
