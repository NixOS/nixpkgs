{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, numpy
, scipy
, scikit-learn
, pandas
, tqdm
, slicer
, numba
, matplotlib
, nose
, ipython
}:

buildPythonPackage rec {
  pname = "shap";
  version = "0.40.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "slundberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ra0dp319qj13wxaqh2vz4xhn59m9h3bfg1m6wf3cxsix737b1k4";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    pandas
    tqdm
    slicer
    numba
  ];

  preCheck = ''
    export HOME=$TMPDIR
    # when importing the local copy the extension is not found
    rm -r shap
  '';
  checkInputs = [ pytestCheckHook matplotlib nose ipython ];
  # Those tests access the network
  disabledTests = [
    "test_kernel_shap_with_a1a_sparse_zero_background"
    "test_kernel_shap_with_a1a_sparse_nonzero_background"
    "test_kernel_shap_with_high_dim_sparse"
    "test_sklearn_random_forest_newsgroups"
    "test_sum_match_random_forest"
    "test_sum_match_extra_trees"
    "test_single_row_random_forest"
    "test_sum_match_gradient_boosting_classifier"
    "test_single_row_gradient_boosting_classifier"
    "test_HistGradientBoostingClassifier_proba"
    "test_HistGradientBoostingClassifier_multidim"
    "test_sum_match_gradient_boosting_regressor"
    "test_single_row_gradient_boosting_regressor"
  ];

  meta = with lib; {
    description = "A unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
    # ModuleNotFoundError: No module named 'sklearn.ensemble.iforest'
    broken = true;
  };
}
