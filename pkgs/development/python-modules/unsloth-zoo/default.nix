{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  accelerate,
  cut-cross-entropy,
  datasets,
  filelock,
  hf-transfer,
  huggingface-hub,
  msgspec,
  numpy,
  packaging,
  peft,
  pillow,
  protobuf,
  psutil,
  regex,
  sentencepiece,
  torch,
  torchao,
  triton,
  tqdm,
  transformers,
  trl,
  tyro,
  typing-extensions,

  # tests
  cudaPackages,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "unsloth-zoo";
  version = "2026.4.7";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit (finalAttrs) version;
    hash = "sha256-jJ58d2+5lEALEaASELZtQkY2YxNWaLrfLvOCUGnwrh4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "setuptools==80.9.0" \
        "setuptools" \
      --replace-fail \
        "setuptools-scm==9.2.0" \
        "setuptools-scm"
  '';

  pythonRelaxDeps = [
    "datasets"
    "torch"
    "transformers"
  ];

  patches = [
    # Avoid circular dependency in Nix, since `unsloth` depends on `unsloth-zoo`.
    ./dont-require-unsloth.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    accelerate
    cut-cross-entropy
    datasets
    filelock
    hf-transfer
    huggingface-hub
    msgspec
    numpy
    packaging
    peft
    pillow
    protobuf
    psutil
    regex
    sentencepiece
    torch
    torchao
    triton
    tqdm
    transformers
    trl
    tyro
    typing-extensions
  ];

  # No tests
  doCheck = false;

  # Importing touches torch.cuda at module import time and queries GPU memory.
  dontUsePythonImportsCheck = true;

  # Cover the import path on GPU-enabled runners instead of pure builders.
  passthru.gpuCheck =
    (cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; }
      {
        libraries = ps: [ ps.unsloth-zoo ];
      }
      ''
        import torch

        assert torch.cuda.is_available(), "CUDA is not available"
        assert torch.ones(1, device="cuda").is_cuda

        import unsloth_zoo  # noqa: F401
        from unsloth_zoo.device_type import DEVICE_COUNT, DEVICE_TYPE

        assert DEVICE_TYPE == "cuda", DEVICE_TYPE
        assert DEVICE_COUNT > 0, DEVICE_COUNT
        print(f"Unsloth Zoo detected {DEVICE_COUNT} CUDA device(s)")
      ''
    ).gpuCheck;

  meta = {
    description = "Utils for Unsloth";
    homepage = "https://github.com/unslothai/unsloth_zoo";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ hoh ];
  };
})
