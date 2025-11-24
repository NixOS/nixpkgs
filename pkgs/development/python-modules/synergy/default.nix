{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  plotly,
  pandas,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "synergy";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "djwooten";
    repo = "synergy";
    tag = "v${version}";
    hash = "sha256-df5CBEcRx55/rSMc6ygMVrHbbEcnU1ISJheO+WoBSCI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
    plotly
    pandas
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # flaky: hypothesis.errors.FailedHealthCheck
    "test_asymptotic_limits"
    "test_inverse"
    # AssertionError: synthetic_BRAID_reference_1.csv
    #  E3=0 not in (0.10639582639915163, 1.6900177333904622)
    "test_BRAID_fit_bootstrap"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: np.False_ is not true
    "test_fit_loewe_antagonism"
  ];

  pythonImportsCheck = [ "synergy" ];

  meta = with lib; {
    description = "Python library for calculating, analyzing, and visualizing drug combination synergy";
    homepage = "https://github.com/djwooten/synergy";
    maintainers = [ ];
    license = licenses.gpl3Plus;
  };
}
