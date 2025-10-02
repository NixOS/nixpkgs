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
  pytestCheckHook,
  pytest-doctestplus,
  pytest-xdist,
  pytorch-lightning,
  scikit-image,

  # passthru
  torchmetrics,
}:

buildPythonPackage rec {
  pname = "torchmetrics";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "torchmetrics";
    tag = "v${version}";
    hash = "sha256-OsU2JpKcbe1AuSIAyZLjDpFdsSk2q3kMGBcNXtIJm3Q=";
  };

  dependencies = [
    numpy
    lightning-utilities
    packaging
  ];

  # Let the user bring their own instance
  buildInputs = [ torch ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-doctestplus
    pytest-xdist
    pytorch-lightning
    scikit-image
  ];

  # A cyclic dependency in: integrations/test_lightning.py
  doCheck = false;
  passthru.tests.check = torchmetrics.overridePythonAttrs (_: {
    pname = "${pname}-check";
    doCheck = true;
    # We don't have to install because the only purpose
    # of this passthru test is to, well, test.
    # This fixes having to set `catchConflicts` to false.
    dontInstall = true;
  });

  disabledTestPaths = [
    # These require too many "leftpad-level" dependencies
    # Also too cross-dependent
    "tests/unittests"

    # AttributeError: partially initialized module 'pesq' has no attribute 'pesq' (most likely due to a circular import)
    "examples/audio/pesq.py"

    # Require internet access
    "examples/text/bertscore.py"
    "examples/image/clip_score.py"
    "examples/text/perplexity.py"
    "examples/text/rouge.py"

    # A trillion import path mismatch errors
    "src/torchmetrics"
  ];

  pythonImportsCheck = [ "torchmetrics" ];

  meta = {
    description = "Machine learning metrics for distributed, scalable PyTorch applications (used in pytorch-lightning)";
    homepage = "https://lightning.ai/docs/torchmetrics/";
    changelog = "https://github.com/Lightning-AI/torchmetrics/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
