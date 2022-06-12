{ lib
, buildPythonPackage
, fetchFromGitHub
, keras
, numba
, numpy
, pynndescent
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, tensorflow
, tqdm
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    hash = "sha256-S2+k7Ec4AxsN6d0GUGnU81oLnBgmlZp8OmUFCNaUJYw=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    pynndescent
    scikit-learn
    scipy
    tqdm
  ];

  checkInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Plot functionality requires additional packages.
    # These test also fail with 'RuntimeError: cannot cache function' error.
    "test_umap_plot_testability"
    "test_plot_runs_at_all"

    # Flaky test. Fails with AssertionError sometimes.
    "test_sparse_hellinger"
    "test_densmap_trustworthiness_on_iris_supervised"

    # tensorflow maybe incompatible? https://github.com/lmcinnes/umap/issues/821
    "test_save_load"
  ];

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
