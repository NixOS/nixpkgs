{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

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
  tqdm,
  transformers,
  triton,
  trl,
  tyro,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "unsloth-zoo";
  version = "2025.12.4";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "unsloth_zoo";
    inherit version;
    hash = "sha256-PdDQzGaZZ3PI3K/7cgDHHF+AnTsT+IPLEqUrDNgbb9M=";
  };

  # pyproject.toml requires an obsolete version of protobuf,
  # but it is not used.
  # Upstream issue: https://github.com/unslothai/unsloth-zoo/pull/68
  pythonRelaxDeps = [
    "datasets"
    "protobuf"
    "trl"
    "transformers"
    "torch"
  ];

  patches = [
    # Avoid circular dependency during import, `unsloth` depends on `unsloth-zoo`.
    ./dont-require-unsloth.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requires = ["setuptools==80.9.0", "setuptools-scm==9.2.0"]' \
                'requires = ["setuptools"]'
  '';

  build-system = [ setuptools ];

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
    tqdm
    transformers
    triton
    trl
    tyro
    typing-extensions
    wheel
  ];

  # No tests
  doCheck = false;

  # Importing tries to detect a GPU and fails in pure CPU builders.
  dontUsePythonImportsCheck = true;

  meta = {
    description = "Utils for Unsloth";
    homepage = "https://github.com/unslothai/unsloth_zoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
