{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,

  # for tests
  rich,
  catboost,
  xgboost,
  lightgbm,
  pandas,
  matplotlib,
  flaky,
  quantile-forest,
  util-linux,

  packaging,
  tabulate,
  huggingface-hub,
  scikit-learn,
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

  # no need coverage tests
  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    packaging
    tabulate
    huggingface-hub
    scikit-learn
  ];

  optional-dependencies = {
    rich = [ rich ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    catboost
    xgboost
    lightgbm
    pandas
    matplotlib
    flaky
    quantile-forest
    util-linux
  ] ++ optional-dependencies.rich;

  pytestFlagsArray = [
    ''-m "not network"''
    "skops"
  ];

  disabledTestPaths = [
    # TODO: need fairlearn python module
    "skops/card/tests/test_card.py"
  ];

  pythonImportsCheck = [
    "skops"
    "skops.hub_utils"
    "skops.card"
    "skops.io"
  ];

  meta = with lib; {
    description = "Python library helping you share your scikit-learn based models and put them in production";
    homepage = "https://github.com/skops-dev/skops";
    changelog = "https://github.com/skops-dev/skops/releases/tag/v${version}";
    broken = stdenv.isDarwin && stdenv.isx86_64;
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
