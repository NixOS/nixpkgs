{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  torch,
  packaging,
  transformers,
  tyro,
  datasets,
  sentencepiece,
  tqdm,
  psutil,
  accelerate,
  trl,
  peft,
  huggingface-hub,
  hf-transfer,
  cut-cross-entropy,

}:

buildPythonPackage rec {
  pname = "unsloth-zoo";
  version = "2025-02-v2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "unsloth-zoo";
    # owner = "unslothai";
    # rev = "31fce522e291e95c3829dc8cc8ac29e03e6c0580";
    # sha256 = "sha256-GGh5B1JF+Q0nRhpUqq7EkwN8X55dUtcZ1/9nmyYpmfQ=";
    # For patching the requirement for deprecated protobuf<4
    owner = "hoh";
    rev = "52c560bc1084222a78a2e2497b13294abf13340e";
    hash = "sha256-bvIE6dvoVEsdTPuk7ILrpyCIhjHQGb+KRG0XNtyvwfE=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [ setuptools-scm ];

  dependencies = [
    torch
    packaging
    tyro
    transformers
    datasets
    sentencepiece
    tqdm
    psutil
    accelerate
    trl
    peft
    huggingface-hub
    hf-transfer
    cut-cross-entropy
  ];

  doCheck = true;

  meta = {
    description = "Utils for Unsloth";
    homepage = "https://github.com/unslothai/unsloth_zoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
