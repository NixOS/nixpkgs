{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  huggingface-hub,
  matplotlib,
  numpy,
  packaging,
  pandas,
  prettytable,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich,
  scikit-learn,
  streamlit,
  tabulate,
}:

buildPythonPackage rec {
  pname = "skops";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skops-dev";
    repo = "skops";
    tag = "v${version}";
    hash = "sha256-1550LIVyChqP5q4VZmflCXPyXXg4eHJU5AlVQJD2M8c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    packaging
    prettytable
    scikit-learn
    tabulate
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytest-cov-stub
    pytestCheckHook
    pyyaml
    streamlit
  ];

  optional-dependencies = {
    rich = [ rich ];
  };

  enabledTestPaths = [ "skops" ];

  disabledTests = [
    # flaky
    "test_base_case_works_as_expected"
    # fairlearn is not available in nixpkgs
    "TestAddFairlearnMetricFrame"
  ];

  disabledTestPaths = [
    # minor output formatting issue
    "skops/card/_model_card.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Segfaults on darwin
    "skops/io/tests/test_persist.py"
  ];

  pytestFlags = [
    # Warning from scipy.optimize in skops/io/tests/test_persist.py::test_dump_and_load_with_file_wrapper
    # https://github.com/skops-dev/skops/issues/479
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "skops" ];

  meta = {
    description = "Library for saving/loading, sharing, and deploying scikit-learn based models";
    homepage = "https://skops.readthedocs.io/en/stable";
    changelog = "https://github.com/skops-dev/skops/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcdarwin ];
    mainProgram = "skops";
  };
}
