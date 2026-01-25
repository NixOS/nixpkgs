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
  hf-transfer,
  huggingface-hub,
  msgspec,
  packaging,
  peft,
  psutil,
  sentencepiece,
  torch,
  tqdm,
  transformers,
  trl,
  tyro,
}:

buildPythonPackage rec {
  pname = "unsloth-zoo";
  version = "2026.1.3";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit version;
    hash = "sha256-njArRI9y6EKwZamJnQoWQIvmYzV6t0syUIi1d7DzX4U=";
  };

  # pyproject.toml requires an obsolete version of protobuf,
  # but it is not used.
  # Upstream issue: https://github.com/unslothai/unsloth-zoo/pull/68
  pythonRelaxDeps = [
    "datasets"
    "protobuf"
    "transformers"
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
    hf-transfer
    huggingface-hub
    msgspec
    packaging
    peft
    psutil
    sentencepiece
    torch
    tqdm
    transformers
    trl
    tyro
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "unsloth_zoo"
  ];

  meta = {
    description = "Utils for Unsloth";
    homepage = "https://github.com/unslothai/unsloth_zoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
