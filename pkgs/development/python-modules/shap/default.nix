{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, writeText
, catboost
, cloudpickle
, ipython
, lightgbm
, lime
, matplotlib
, nose
, numba
, numpy
, oldest-supported-numpy
, opencv4
, pandas
, pyspark
, pytest-mpl
, scikit-learn
, scipy
, sentencepiece
, setuptools
, slicer
, tqdm
, transformers
, xgboost
, wheel
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.42.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = "shap";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ezq6WS6QnoM5uEfo2DgDAEo1HkQ1KjmfgIyVWh3RM94=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    cloudpickle
    numba
    numpy
    pandas
    scikit-learn
    scipy
    slicer
    tqdm
  ];

  passthru.optional-dependencies = {
    plots = [ matplotlib ipython ];
    others = [ lime ];
  };

  preCheck = let
    # This pytest hook mocks and catches attempts at accessing the network
    # tests that try to access the network will raise, get caught, be marked as skipped and tagged as xfailed.
    conftestSkipNetworkErrors = writeText "conftest.py" ''
      from _pytest.runner import pytest_runtest_makereport as orig_pytest_runtest_makereport
      import urllib, requests, transformers

      class NetworkAccessDeniedError(RuntimeError): pass
      def deny_network_access(*a, **kw):
        raise NetworkAccessDeniedError

      requests.head = deny_network_access
      requests.get  = deny_network_access
      urllib.request.urlopen = deny_network_access
      urllib.request.Request = deny_network_access
      transformers.AutoTokenizer.from_pretrained = deny_network_access

      def pytest_runtest_makereport(item, call):
        tr = orig_pytest_runtest_makereport(item, call)
        if call.excinfo is not None and call.excinfo.type is NetworkAccessDeniedError:
            tr.outcome = 'skipped'
            tr.wasxfail = "reason: Requires network access."
        return tr
    '';
  in ''
    export HOME=$TMPDIR
    # when importing the local copy the extension is not found
    rm -r shap

    # Add pytest hook skipping tests that access network.
    # These tests are marked as "Expected fail" (xfail)
    cat ${conftestSkipNetworkErrors} >> tests/conftest.py
  '';

  nativeCheckInputs = [
    ipython
    matplotlib
    nose
    pytest-mpl
    pytestCheckHook
    # optional dependencies, which only serve to enable more tests:
    catboost
    lightgbm
    opencv4
    pyspark
    sentencepiece
    #torch # we already skip all its tests due to slowness, adding it does nothing
    transformers
    xgboost
  ];

  disabledTestPaths = [
    # The resulting plots look sane, but does not match pixel-perfectly with the baseline.
    # Likely due to a matplotlib version mismatch, different backend, or due to missing fonts.
    "tests/plots/test_summary.py" # FIXME: enable
  ];

  disabledTests = [
    # The same reason as above test_summary.py
    "test_simple_bar_with_cohorts_dict"
    "test_random_summary_violin_with_data2"
    "test_random_summary_layered_violin_with_data2"
  ];

  pythonImportsCheck = [
    "shap"
    "shap.explainers"
    "shap.explainers.other"
    "shap.plots"
    "shap.plots.colors"
    "shap.benchmark"
    "shap.maskers"
    "shap.utils"
    "shap.actions"
    "shap.models"
  ];

  meta = with lib; {
    description = "A unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
    changelog = "https://github.com/slundberg/shap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ evax natsukium ];
  };
}
