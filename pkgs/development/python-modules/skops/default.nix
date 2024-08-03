{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  huggingface-hub,
  matplotlib,
  pandas,
  scikit-learn,
  streamlit,
  tabulate,
}:

buildPythonPackage rec {
  pname = "skops";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "skops-dev";
    repo = "skops";
    rev = "refs/tags/v${version}";
    hash = "sha256-JCK5x2OKRcUftld+bGgHD74eB3Jmij2PZnOPIenTRlM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace-fail "--cov=skops" ""  \
      --replace-fail "--cov-report=term-missing" ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    huggingface-hub
    scikit-learn
    tabulate
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
    streamlit
  ];
  pytestFlagsArray = [ "skops" ];
  disabledTestPaths = [
    # try to download data from Huggingface Hub:
    "skops/hub_utils/tests"
    "skops/card/tests"
    # minor output formatting issue
    "skops/card/_model_card.py"
  ];

  pythonImportsCheck = [ "skops" ];

  meta = {
    description = "Library for saving/loading, sharing, and deploying scikit-learn based models";
    mainProgram = "skops";
    homepage = "https://skops.readthedocs.io/en/stable";
    changelog = "https://github.com/skops-dev/skops/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
