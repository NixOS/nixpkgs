{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  huggingface-hub,
  matplotlib,
  pandas,
  scikit-learn,
  stdenv,
  streamlit,
  tabulate,
}:

buildPythonPackage rec {
  pname = "skops";
  version = "0.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "skops-dev";
    repo = "skops";
    rev = "refs/tags/v${version}";
    hash = "sha256-2uX5sGVdTnZEbl0VXI8E7h1pQYQVbpQeUKUchCZpgg4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    scikit-learn
    tabulate
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
    pytest-cov-stub
    streamlit
  ];
  pytestFlagsArray = [ "skops" ];
  disabledTestPaths =
    [
      # try to download data from Huggingface Hub:
      "skops/hub_utils/tests"
      "skops/card/tests"
      # minor output formatting issue
      "skops/card/_model_card.py"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Segfaults on darwin
      "skops/io/tests/test_persist.py"
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
