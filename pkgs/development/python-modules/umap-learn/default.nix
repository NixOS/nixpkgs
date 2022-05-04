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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "sha256-S2+k7Ec4AxsN6d0GUGnU81oLnBgmlZp8OmUFCNaUJYw=";
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
