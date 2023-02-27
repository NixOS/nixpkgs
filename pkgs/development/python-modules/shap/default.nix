{ lib
, buildPythonPackage
, fetchFromGitHub
, writeText
, isPy27
, pytestCheckHook
, pytest-mpl
, numpy
, scipy
, scikit-learn
, pandas
, transformers
, opencv4
, lightgbm
, catboost
, pyspark
, sentencepiece
, tqdm
, slicer
, numba
, matplotlib
, nose
, lime
, cloudpickle
, ipython
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.41.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-rYVWQ3VRvIObSQPwDRsxhTOGOKNkYkLtiHzVwoB3iJ0=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    pandas
    tqdm
    slicer
    numba
    cloudpickle
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
      import urllib, requests

      class NetworkAccessDeniedError(RuntimeError): pass
      def deny_network_access(*a, **kw):
        raise NetworkAccessDeniedError

      requests.head = deny_network_access
      requests.get  = deny_network_access
      urllib.request.urlopen = deny_network_access
      urllib.request.Request = deny_network_access

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

    # coverage testing is a waste considering how much we have to skip
    substituteInPlace pytest.ini \
      --replace "--cov=shap --cov-report=term-missing" ""

    # Add pytest hook skipping tests that access network.
    # These tests are marked as "Expected fail" (xfail)
    cat ${conftestSkipNetworkErrors} >> tests/conftest.py
  '';
  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    matplotlib
    nose
    ipython
    # optional dependencies, which only serve to enable more tests:
    opencv4
    #pytorch # we already skip all its tests due to slowness, adding it does nothing
    transformers
    #xgboost # numerically unstable? xgboost tests randomly fails pending on nixpkgs revision
    lightgbm
    catboost
    pyspark
    sentencepiece
  ];
  disabledTestPaths = [
    # takes forever without GPU acceleration
    "tests/explainers/test_deep.py"
    "tests/explainers/test_gradient.py"
    # requires GPU. We skip here instead of having pytest repeatedly check for GPU
    "tests/explainers/test_gpu_tree.py"
    # The resulting plots look sane, but does not match pixel-perfectly with the baseline.
    # Likely due to a matplotlib version mismatch, different backend, or due to missing fonts.
    "tests/plots/test_summary.py" # FIXME: enable
    # 100% of the tests in these paths require network
    "tests/explainers/test_explainer.py"
    "tests/explainers/test_exact.py"
    "tests/explainers/test_partition.py"
    "tests/maskers/test_fixed_composite.py"
    "tests/maskers/test_text.py"
    "tests/models/test_teacher_forcing_logits.py"
    "tests/models/test_text_generation.py"
  ];
  disabledTests = [
    # unstable. A xgboost-enabled test. possibly related: https://github.com/slundberg/shap/issues/2480
    "test_provided_background_tree_path_dependent"
  ];

  #pytestFlagsArray = ["-x" "-W" "ignore"]; # uncomment this to debug

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
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
