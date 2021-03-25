{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, scikitlearn
, scipy
, numba
, pynndescent
, tensorflow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "sha256-2Z5RDi4bz8hh8zMwkcCQY9NrGaVd1DJEBOmrCl2oSvM=";
  };

  checkInputs = [
    nose
    tensorflow
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    numpy
    scikitlearn
    scipy
    numba
    pynndescent
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
