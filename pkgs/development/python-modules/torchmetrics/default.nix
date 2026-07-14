{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  numpy,
  lightning-utilities,
  packaging,

  # buildInputs
  torch,

  # tests
  ipython,
  pytestCheckHook,
  pytest-doctestplus,
  pytest-xdist,
  pytorch-lightning,
  scikit-image,
  transformers,

  # passthru
  torchmetrics,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchmetrics";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "torchmetrics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jlIZQWu0lE37Gv0Rzmgm+kG3dEeT1p3pKdXzkUgq3Rw=";
  };

  dependencies = [
    numpy
    lightning-utilities
    packaging
  ];

  # Let the user bring their own instance
  buildInputs = [ torch ];

  nativeCheckInputs = [
    ipython
    pytestCheckHook
    pytest-doctestplus
    pytest-xdist
    pytorch-lightning
    scikit-image
    transformers
  ];

  # A cyclic dependency in: integrations/test_lightning.py
  doCheck = false;
  passthru.tests.check = torchmetrics.overridePythonAttrs (_: {
    pname = "${finalAttrs.pname}-check";
    doCheck = true;
    # We don't have to install because the only purpose
    # of this passthru test is to, well, test.
    # This fixes having to set `catchConflicts` to false.
    dontInstall = true;
  });

  pytestFlags = [
    # The (path: py.path.local) argument is deprecated, please use (file_path: pathlib.Path)
    "-Wignore::pytest.PytestRemovedIn9Warning"
  ];

  disabledTestPaths = [
    # These require too many "leftpad-level" dependencies
    # Also too cross-dependent
    "tests/unittests"

    # AttributeError: partially initialized module 'pesq' has no attribute 'pesq' (most likely due to a circular import)
    "examples/audio/pesq.py"

    # Require internet access
    "examples/audio/text_to_speech.py"
    "examples/image/clip_score.py"
    "examples/text/bertscore.py"
    "examples/text/perplexity.py"
    "examples/text/rouge.py"

    # A trillion import path mismatch errors
    "src/torchmetrics"
  ];

  pythonImportsCheck = [ "torchmetrics" ];

  meta = {
    description = "Machine learning metrics for distributed, scalable PyTorch applications (used in pytorch-lightning)";
    homepage = "https://lightning.ai/docs/torchmetrics/";
    changelog = "https://github.com/Lightning-AI/torchmetrics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
})
