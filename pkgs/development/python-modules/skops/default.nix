{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
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
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "skops-dev";
    repo = "skops";
    tag = "v${version}";
    hash = "sha256-23Wy/VSd/CvpqT/zDX4ApplfsUwbjOj9q+T8YCKs8X4=";
  };

  build-system = [ hatchling ];

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
  disabledTests = [
    # flaky
    "test_base_case_works_as_expected"
  ];
  disabledTestPaths =
    [
      # try to download data from Huggingface Hub:
      "skops/hub_utils/tests"
      "skops/card/tests"
      # minor output formatting issue
      "skops/card/_model_card.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Segfaults on darwin
      "skops/io/tests/test_persist.py"
    ];

  pythonImportsCheck = [ "skops" ];

  meta = {
    description = "Library for saving/loading, sharing, and deploying scikit-learn based models";
    mainProgram = "skops";
    homepage = "https://skops.readthedocs.io/en/stable";
    changelog = "https://github.com/skops-dev/skops/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
