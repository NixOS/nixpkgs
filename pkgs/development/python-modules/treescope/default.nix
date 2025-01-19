{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  numpy,

  # optional-dependencies
  ipython,
  jax,
  palettable,

  # tests
  absl-py,
  jaxlib,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "treescope";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "treescope";
    tag = "v${version}";
    hash = "sha256-fDwiKKXgisJ4Z/CBv4Vwtd7QaGscu5teZo11mSGZjbE=";
  };

  build-system = [ flit-core ];

  dependencies = [ numpy ];

  optional-dependencies = {
    notebook = [
      ipython
      jax
      palettable
    ];
  };

  pythonImportsCheck = [ "treescope" ];

  nativeCheckInputs = [
    absl-py
    jax
    jaxlib
    pytestCheckHook
    torch
  ];

  meta = {
    description = "An interactive HTML pretty-printer for machine learning research in IPython notebooks";
    homepage = "https://github.com/google-deepmind/treescope";
    changelog = "https://github.com/google-deepmind/treescope/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
