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
  omegaconf,
  pydantic,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "treescope";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "treescope";
    tag = "v${version}";
    hash = "sha256-rLrsG7psY3xkuvNtdRULiMWKzIiWZpJ7TVJhwTNGXRQ=";
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
    omegaconf
    pydantic
    pytestCheckHook
    torch
  ];

  disabledTests = [
    # AttributeError: jax.sharding.GSPMDSharding was deprecated in JAX v0.6.0 and removed in JAX v0.7.0. Did you mean: 'NamedSharding'?
    # https://github.com/google-deepmind/treescope/issues/67
    "NdarrayAdaptersTest"
  ];

  meta = {
    description = "Interactive HTML pretty-printer for machine learning research in IPython notebooks";
    homepage = "https://github.com/google-deepmind/treescope";
    changelog = "https://github.com/google-deepmind/treescope/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
