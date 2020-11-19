{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, scikitlearn
, scipy
, numba
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "080by8h4rxr5ijx8vp8kn952chiqz029j26c04k4js4g9s7201bq";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    numpy
    scikitlearn
    scipy
    numba
  ];

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
