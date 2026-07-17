{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  hyperpyyaml,
  joblib,
  numpy,
  packaging,
  requests,
  scipy,
  sentencepiece,
  soundfile,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "speechbrain";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "speechbrain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-98g9HSCD6ahsmCSKSKIY1okYOuzUqVuJO9N9WUiZMPk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    hyperpyyaml
    joblib
    numpy
    packaging
    requests
    scipy
    sentencepiece
    soundfile
    torch
    torchaudio
    tqdm
  ];

  pythonImportsCheck = [ "speechbrain" ];

  doCheck = false; # requires sox backend

  meta = {
    description = "PyTorch-based Speech Toolkit";
    homepage = "https://speechbrain.github.io";
    changelog = "https://github.com/speechbrain/speechbrain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
