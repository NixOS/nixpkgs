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
  version = "2026.4.2";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit (finalAttrs) version;
    hash = "sha256-l0OTaZjPrNnrxVYIfZcf6pYr1tJS9EGj+iguU6S+D28=";
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

  # Upstream constrains datasets/torch more tightly than the versions
  # currently shipped in nixpkgs, but the package still builds and works with
  # the newer dependency set here.
  pythonRelaxDeps = [
    "datasets"
    "torch"
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
