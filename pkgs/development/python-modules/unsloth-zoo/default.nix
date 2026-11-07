{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  accelerate,
  certifi,
  cut-cross-entropy,
  datasets,
  einops,
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
  requests,
  sentencepiece,
  torch,
  torchao,
  triton,
  tqdm,
  transformers,
  trl,
  typing-extensions,
  wheel,

  # tests
  cudaPackages,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "unsloth-zoo";
  version = "2026.11.2";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit (finalAttrs) version;
    hash = "sha256-vYUhoIENyDluEO+vlc9fZWPxHvvIKtJm8324iRgw9iQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.2.1" "setuptools" \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "setuptools-scm==10.3.4" "setuptools-scm"
  ''
  # Avoid circular dependency in Nix, since `unsloth` depends on `unsloth-zoo`.
  + ''
    substituteInPlace unsloth_zoo/__init__.py \
      --replace-fail \
        'raise ImportError("Please install Unsloth via `pip install unsloth`!")' \
        'pass'
  '';

  pythonRelaxDeps = [
    "certifi"
    "datasets"
    "transformers"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    accelerate
    certifi
    cut-cross-entropy
    datasets
    einops
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
    requests
    sentencepiece
    torch
    torchao
    triton
    tqdm
    transformers
    trl
    typing-extensions
    wheel
  ];

  # No tests
  doCheck = false;

  # Without a GPU, unsloth falls back to its CPU backend.
  pythonImportsCheck = [ "unsloth_zoo" ];

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
    license = with lib.licenses; [
      lgpl3Plus
      # Several code sections are AGPL-3.0-only.
      agpl3Only
      # Vendored flash-linear-attention
      mit
    ];
    maintainers = with lib.maintainers; [ hoh ];
  };
})
