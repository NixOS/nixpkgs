{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  writeText,
  catboost,
  cloudpickle,
  cython,
  ipython,
  lightgbm,
  lime,
  matplotlib,
  numba,
  numpy,
  opencv4,
  pandas,
  pyspark,
  pytest-mpl,
  scikit-learn,
  scipy,
  sentencepiece,
  setuptools,
  setuptools-scm,
  slicer,
  tqdm,
  transformers,
  xgboost,
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.48.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = "shap";
    tag = "v${version}";
    hash = "sha256-eWZhyrFpEFlmTFPTHZng9V+uMRMXDVzFdgrqIzRQTws=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython>=3.0.11" cython \
      --replace-fail "numpy>=2.0" "numpy"
  '';

  build-system = [
    cython
    numpy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cloudpickle
    numba
    numpy
    pandas
    scikit-learn
    scipy
    slicer
    tqdm
  ];

  optional-dependencies = {
    plots = [
      matplotlib
      ipython
    ];
    others = [ lime ];
  };

  preCheck =
    let
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
    in
    ''
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

  # Test startup hangs with 0.43.0 and Hydra ends with a timeout
  doCheck = false;

  disabledTestPaths = [
    # The resulting plots look sane, but does not match pixel-perfectly with the baseline.
    # Likely due to a matplotlib version mismatch, different backend, or due to missing fonts.
    "tests/plots/test_summary.py" # FIXME: enable
  ];

  disabledTests = [
    # The same reason as above test_summary.py
    "test_random_force_plot_negative_sign"
    "test_random_force_plot_positive_sign"
    "test_random_summary_layered_violin_with_data2"
    "test_random_summary_violin_with_data2"
    "test_simple_bar_with_cohorts_dict"
  ];

  pythonImportsCheck = [ "shap" ];

  meta = with lib; {
    description = "Unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
    changelog = "https://github.com/slundberg/shap/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      evax
      natsukium
    ];
  };
}
