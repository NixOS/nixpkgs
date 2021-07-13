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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "0favphngcz5jvyqs06x07hk552lvl9qx3vka8r4x0xmv88gsg349";
  };

  propagatedBuildInputs = [
    numpy
    scikit-learn
    scipy
    numba
    pynndescent
  ];

  checkInputs = [
    nose
    tensorflow
    pytestCheckHook
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
  ];

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
