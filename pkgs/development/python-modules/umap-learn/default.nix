{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, scikit-learn
, scipy
, numba
, pynndescent
, tensorflow
, tqdm
, pytestCheckHook
, keras
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "sha256-JfYuuE1BP+HdiEl7l01sZ/XXlEwHyAsLjK9nqhRd/3o=";
  };

  propagatedBuildInputs = [
    numpy
    scikit-learn
    scipy
    numba
    pynndescent
    tqdm
  ];

  checkInputs = [
    nose
    tensorflow
    pytestCheckHook
    keras
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

    # tensorflow maybe incompatible? https://github.com/lmcinnes/umap/issues/821
    "test_save_load"
  ];

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
