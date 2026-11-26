{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  ninja,
  setuptools,
  torch,

  # dependencies
  einops,

  # tests
  apex,
  pytestCheckHook,
  sentencepiece,
  timm,
  transformers,
  writableTmpDirAsHomeHook,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;

  # The kernels are generic sm_80+ code (guarded by `__CUDA_ARCH__ >= 800`), older ones would only
  # get stubs that print "FATAL: FlashAttention requires building with sm version sm80-sm90".
  supportedCudaCapabilities = lib.filter (lib.flip lib.versionAtLeast "8.0") cudaCapabilities;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flash-attn";
  version = "2.8.3.post2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-bMFvcVpOMSM0YrU7pmtwNWDubhdbWVqiu9DsPF3J1Hg=";
  };

  postPatch =
    # Avoid that MAX_JOBS could be ignored with future updates
    ''
      substituteInPlace setup.py \
        --replace-fail '"psutil",' ""
    ''
    # torch>=2.13 headers require C++20
    # https://github.com/Dao-AILab/flash-attention/pull/2899
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          '"-std=c++17"' \
          '"-std=c++20"'
    ''
    # setup.py only emits `-gencode` for the exact archs 80, 90, 100 and 120 (silently dropping 86,
    # 89, 90a, 103, ...), which also makes torch ignore TORCH_CUDA_ARCH_LIST.
    # Emit none, so that torch builds every requested capability instead.
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          'os.getenv("FLASH_ATTN_CUDA_ARCHS", "80;90;100;120").split(";")' \
          '[]'
    '';

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS=2
  '';

  env = lib.optionalAttrs cudaSupport {
    FORCE_BUILD = "TRUE";
    FLASH_ATTENTION_SKIP_CUDA_BUILD = "FALSE";

    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" supportedCudaCapabilities;
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cccl # <thrust/*>
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcurand # curand.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.cuda_cudart # cuda_runtime.h cuda_runtime_api.h
  ];

  dependencies = [
    einops
    torch
  ];

  # The CuTeDSL implementation (flash_attn/cute) is the FlashAttention-4 module,
  # packaged separately as `flash-attn-4`. Drop the stale snapshot bundled in this
  # FA2 release so the two packages don't collide on flash_attn/cute/ when a single
  # environment installs both.
  postInstall = ''
    rm -rf "$out/${python.sitePackages}/flash_attn/cute"
  '';

  pythonImportsCheck = [ "flash_attn" ];

  nativeCheckInputs = [
    apex
    pytestCheckHook
    sentencepiece
    timm
    transformers
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = [
    # `fused_dense_lib` and `dropout_layer_norm` live under csrc/ as standalone Python packages
    # with their own setup.py; the top-level setup.py does not build them, and they are not
    # shipped on PyPI either.
    "tests/ops/test_dropout_layer_norm.py"
    "tests/ops/test_fused_dense.py"
    "tests/ops/test_fused_dense_parallel.py"

    # Imports `RotaryEmbedding` from `transformers.models.gpt_neox.modeling_gpt_neox`, which
    # upstream transformers has since removed.
    "tests/layers/test_rotary.py"

    # Tests the ROCm composable_kernel backend; we only build the CUDA backend.
    "tests/test_flash_attn_ck.py"

    # Module-name collision with tests/test_flash_attn.py (both import as
    # `test_flash_attn`). Disable the CUTE-DSL variant and keep the tests that
    # exercise the C++ extension we actually build.
    "tests/cute/test_flash_attn.py"
  ];

  preCheck = ''
    rm -rf flash_attn
  '';

  # Tests require access to a physical GPU
  doCheck = false;

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doInstallCheck = true;
    };
  };

  meta = {
    # Upstream requires either CUDA or ROCm. Couldn't get it to work with ROCm for now.
    broken = !cudaSupport;
    # The result would refuse to run on any of the requested GPUs.
    problems = lib.optionalAttrs (cudaSupport && supportedCudaCapabilities == [ ]) {
      unsupported-cuda-capabilities = {
        kind = "broken";
        message = ''
          flash-attn requires CUDA capability 8.0 or newer.
            - Got: ${lib.concatStringsSep ", " cudaCapabilities}
        '';
      };
    };
    description = "Official implementation of FlashAttention and FlashAttention-2";
    homepage = "https://github.com/Dao-AILab/flash-attention/";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
