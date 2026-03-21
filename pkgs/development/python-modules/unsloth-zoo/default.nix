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

buildPythonPackage (finalAttrs: {
  pname = "unsloth-zoo";
  version = "2026.3.4";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit (finalAttrs) version;
    hash = "sha256-24w8UV5cLG5XWrU73xfmg+Jk32zl+QSPdqXLzMtmP1E=";
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

  # pyproject.toml requires an obsolete version of protobuf,
  # but it is not used.
  # Upstream issue: https://github.com/unslothai/unsloth-zoo/pull/68
  pythonRelaxDeps = [
    "datasets"
    "protobuf"
    "transformers"
    "trl"
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

  pythonImportsCheck = [ "unsloth_zoo" ];

  meta = {
    description = "Utils for Unsloth";
    homepage = "https://github.com/unslothai/unsloth_zoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
})
