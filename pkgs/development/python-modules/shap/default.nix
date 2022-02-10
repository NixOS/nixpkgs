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
, cloudpickle
, numba
, matplotlib
, nose
, pytest-mpl
, pytest-cov
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
    cloudpickle
  ];

  preCheck = ''
    export HOME=$TMPDIR
    # when importing the local copy the extension is not found
    rm -r shap
  '';
  checkInputs = [
    pytestCheckHook
    matplotlib
    nose
    ipython
    pytest-mpl
    pytest-cov
  ];
  # Those tests access the network
  pytestFlagsArray = [
    "--deselect" "tests/explainers/test_kernel.py::test_kernel_shap_with_a1a_sparse_zero_background"
    "--deselect" "tests/explainers/test_kernel.py::test_kernel_shap_with_a1a_sparse_nonzero_background"
    "--deselect" "tests/explainers/test_kernel.py::test_kernel_shap_with_high_dim_sparse"
    "--deselect" "tests/explainers/test_tree.py::test_sum_match_random_forest"
    "--deselect" "tests/explainers/test_tree.py::test_sum_match_extra_trees"
    "--deselect" "tests/explainers/test_tree.py::test_single_row_random_forest"
    "--deselect" "tests/explainers/test_tree.py::test_sum_match_gradient_boosting_classifier"
    "--deselect" "tests/explainers/test_tree.py::test_single_row_gradient_boosting_classifier"
    "--deselect" "tests/explainers/test_tree.py::test_HistGradientBoostingClassifier_proba"
    "--deselect" "tests/explainers/test_tree.py::test_HistGradientBoostingClassifier_multidim"
    "--deselect" "tests/explainers/test_tree.py::test_sum_match_gradient_boosting_regressor"
    "--deselect" "tests/explainers/test_tree.py::test_single_row_gradient_boosting_regressor"
    "--deselect" "tests/explainers/test_tree.py::test_sklearn_random_forest_newsgroups"
    "--deselect" "tests/plots/test_dependence_string_features.py::test_dependence_one_string_feature"
    "--deselect" "tests/plots/test_dependence_string_features.py::test_dependence_two_string_features"
    "--deselect" "tests/plots/test_dependence_string_features.py::test_dependence_one_string_feature_no_interaction"
    "--deselect" "tests/plots/test_dependence_string_features.py::test_dependence_one_string_feature_auto_interaction"
    "--deselect" "tests/plots/test_summary.py::test_random_summary"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_with_data"
    "--deselect" "tests/plots/test_summary.py::test_random_multi_class_summary"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_bar_with_data"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_dot_with_data"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_violin_with_data"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_layered_violin_with_data"
    "--deselect" "tests/plots/test_summary.py::test_random_summary_with_log_scale"
  ];

  meta = with lib; {
    description = "A unified approach to explain the output of any machine learning model";
    homepage = "https://github.com/slundberg/shap";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
