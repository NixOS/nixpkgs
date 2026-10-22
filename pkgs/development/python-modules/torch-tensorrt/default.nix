{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cudaPackages,
  nix-update-script,

  # build-system
  pyyaml,
  setuptools,

  # dependencies
  dllist,
  filelock,
  numpy,
  packaging,
  psutil,
  tensorrt,
  torch,
  typing-extensions,

  # optional-dependencies
  cuda-core,

  # tests
  expecttest,
  parameterized,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-tensorrt";
  # Releases track PyTorch minor versions (each requires torch>=X.Y,<X.(Y+1)); keep this in step with torch.
  version = "2.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "TensorRT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBnEy/BMwweEt9V41i2WnT3oJxqrrKLHZLXpclAvcwc=";
  };

  patches = [
    # Don't query the CUDA device on import (`import torch_tensorrt` fails without a GPU, as in pythonImportsCheck)
    # https://github.com/pytorch/TensorRT/pull/4504
    (fetchpatch {
      name = "fix-cpu-only-import.patch";
      url = "https://github.com/pytorch/TensorRT/commit/1caa73d0748391700d53ef4c3c66d1a78650766f.patch";
      hash = "sha256-wCv+xXjjohW/b2WciwWCJVOe9qkYB8icttxFDDKqOo4=";
    })
  ];

  postPatch =
    # cffi, ninja and pybind11 (pinned to 2.6.2) are only used to build the C++ extension, which isn't built here.
    ''
      sed -i -E '/^ *"(cffi|ninja|pybind11)[<>=]/d' pyproject.toml
    ''
    # The version of TensorRT recorded in torch_tensorrt._version, which is only used to find libnvinfer.so.<major> on
    # the host when `import tensorrt` fails.
    + ''
      sed -i 's/^__tensorrt_version__: .*/__tensorrt_version__: "${tensorrt.version}"/' dev_dep_versions.yml
    '';

  env = {
    # Build only the Python package: the dynamo and torch.compile frontends with the Python TensorRT runtime. The C++
    # parts (libtorchtrt_runtime, used by the C++ runtime, and libtorchtrt, for the TorchScript frontend) need Bazel
    # with dependencies fetched from the network, and the CMake build upstream ships is not maintained (it is missing
    # sources Bazel builds). Without the C++ runtime, compiled modules use the Python runtime
    # (`use_python_runtime=True`) and can't be serialized with TorchScript or torch.export's C++ ops, or run from C++;
    # `ENABLED_FEATURES.torch_tensorrt_runtime` and `.torchscript_frontend` are False.
    PYTHON_ONLY = "1";

    # Use `version` rather than `<version.txt>.dev0+<git hash>`.
    RELEASE = "1";
    BUILD_VERSION = finalAttrs.version;

    # The NGC container ("DLFW") build mode: torch and tensorrt are left out of the requirements, as they come from the
    # environment. Otherwise setup.py pins them to the release's minor versions and adds the CUDA-specific
    # tensorrt-cu1x(-bindings,-libs) wheels, which Nixpkgs' tensorrt doesn't provide as separate distributions.
    CI_PIPELINE_ID = "nixpkgs";

    # Recorded in torch_tensorrt.__cuda_version__ instead of the version in dev_dep_versions.yml.
    CU_VERSION = "cu${lib.replaceStrings [ "." ] [ "" ] cudaPackages.cudaMajorMinorVersion}";
  };

  # setup.py imports torch.
  build-system = [
    packaging
    pyyaml
    setuptools
    torch
  ];

  dependencies = [
    dllist
    filelock
    numpy
    packaging
    psutil
    tensorrt
    torch
    typing-extensions
  ];

  # Leaves out the executorch extra, which needs the C++ runtime.
  optional-dependencies = {
    # Upstream lists cuda-python; torch_tensorrt.kernels uses cuda.core.
    kernels = [ cuda-core ];
  };

  pythonImportsCheck = [ "torch_tensorrt" ];

  nativeCheckInputs = [
    expecttest
    parameterized
    pytestCheckHook
  ];

  pytestFlags = [
    # Drop upstream's `-n auto` (pytest-xdist), which runs a process per core on one GPU.
    "--override-ini=addopts="
  ];

  enabledTestPaths = [
    "tests/py/dynamo/backend"
    "tests/py/dynamo/runtime"
  ];

  # Tests need a GPU.
  doCheck = false;

  passthru = {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doInstallCheck = true;
    };

    # Only follow releases for torch's minor version.
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(${lib.escapeRegex (lib.versions.majorMinor torch.version)}\\..*)$"
      ];
    };
  };

  meta = {
    description = "PyTorch compiler for NVIDIA GPUs using TensorRT";
    homepage = "https://docs.pytorch.org/TensorRT/";
    downloadPage = "https://github.com/pytorch/TensorRT";
    changelog = "https://github.com/pytorch/TensorRT/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    problems =
      lib.optionalAttrs
        (
          !torch.cudaSupport
          || lib.versions.majorMinor torch.version != lib.versions.majorMinor finalAttrs.version
        )
        {
          broken.message =
            "torch-tensorrt ${finalAttrs.version} needs a CUDA build of torch ${lib.versions.majorMinor finalAttrs.version}.x;"
            + " got torch ${torch.version}${lib.optionalString (!torch.cudaSupport) " without CUDA"}.";
        };
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.linux;
  };
})
