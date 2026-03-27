{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  numpy,
  packaging,
  prettytable,
  scikit-learn,
  tabulate,

  # tests
  matplotlib,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  rich,
  streamlit,
}:

buildPythonPackage (finalAttrs: {
  pname = "skops";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skops-dev";
    repo = "skops";
    tag = "v${finalAttrs.version}";
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

    # numpy.linalg.LinAlgError: The covariance matrix of class 0 is not full rank.
    # Increase the value of `reg_param` to reduce the collinearity.
    "test_can_persist_fitted"

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

    # FutureWarning: Class PassiveAggressiveClassifier is deprecated; this is deprecated in version
    # 1.8 and will be removed in 1.10. Use `SGDClassifier(...)` instead.
    "-Wignore::FutureWarning"
  ];

  pythonImportsCheck = [ "skops" ];

  meta = {
    description = "Library for saving/loading, sharing, and deploying scikit-learn based models";
    homepage = "https://skops.readthedocs.io/en/stable";
    changelog = "https://github.com/skops-dev/skops/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcdarwin ];
    mainProgram = "skops";
  };
})
