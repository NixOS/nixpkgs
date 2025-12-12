{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  hyperpyyaml,
  joblib,
  numpy,
  packaging,
  sentencepiece,
  scipy,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage rec {
  pname = "speechbrain";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "speechbrain";
    tag = "v${version}";
    hash = "sha256-H45kTOIO6frbrRu+TP+udn1z60ZEcrShNB9iTCLInQs=";
  };

  patches = [
    # https://github.com/speechbrain/speechbrain/pull/2988
    (fetchpatch {
      name = "torchaudio-2.9-compat.patch";
      url = "https://github.com/speechbrain/speechbrain/commit/927530fa95e238fbc396000618e839a4a986dd7d.patch";
      excludes = [ "pyproject.toml" ];
      hash = "sha256-TJxBQLggX2ZHppUJwMcg9+A9r0r+D20XUfivBFW7y/U=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    hyperpyyaml
    joblib
    numpy
    packaging
    sentencepiece
    scipy
    torch
    torchaudio
    tqdm
  ];

  doCheck = false; # requires sox backend

  pythonImportsCheck = [ "speechbrain" ];

  meta = {
    description = "PyTorch-based Speech Toolkit";
    homepage = "https://speechbrain.github.io";
    changelog = "https://github.com/speechbrain/speechbrain/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # See https://github.com/NixOS/nixpkgs/issues/466092
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
