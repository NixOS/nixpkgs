{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "shap";
<<<<<<< HEAD
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
=======
  version = "0.41.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rYVWQ3VRvIObSQPwDRsxhTOGOKNkYkLtiHzVwoB3iJ0=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      import urllib, requests, transformers
=======
      import urllib, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      class NetworkAccessDeniedError(RuntimeError): pass
      def deny_network_access(*a, **kw):
        raise NetworkAccessDeniedError

      requests.head = deny_network_access
      requests.get  = deny_network_access
      urllib.request.urlopen = deny_network_access
      urllib.request.Request = deny_network_access
<<<<<<< HEAD
      transformers.AutoTokenizer.from_pretrained = deny_network_access
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
=======
    # coverage testing is a waste considering how much we have to skip
    substituteInPlace pytest.ini \
      --replace "--cov=shap --cov-report=term-missing" ""

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Add pytest hook skipping tests that access network.
    # These tests are marked as "Expected fail" (xfail)
    cat ${conftestSkipNetworkErrors} >> tests/conftest.py
  '';
<<<<<<< HEAD

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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ evax natsukium ];
=======
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
    # No support for scikit-learn > 1.2
    # https://github.com/slundberg/shap/issues/2866
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
