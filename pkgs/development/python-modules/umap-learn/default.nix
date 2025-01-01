{
  lib,
  bokeh,
  buildPythonPackage,
  colorcet,
  datashader,
  fetchFromGitHub,
  holoviews,
  matplotlib,
  numba,
  numpy,
  pandas,
  pynndescent,
  pytestCheckHook,
  pythonOlder,
  scikit-image,
  scikit-learn,
  scipy,
  seaborn,
  tensorflow,
  tensorflow-probability,
  tqdm,
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = "refs/tags/release-${version}";
    hash = "sha256-fqYl8T53BgCqsquY6RJHqpDFsdZA0Ihja69E/kG3YGU=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    pynndescent
    scikit-learn
    scipy
    tqdm
  ];

  optional-dependencies = rec {
    plot = [
      bokeh
      colorcet
      datashader
      holoviews
      matplotlib
      pandas
      scikit-image
      seaborn
    ];

    parametric_umap = [
      tensorflow
      tensorflow-probability
    ];

    tbb = [ tbb ];

    all = plot ++ parametric_umap ++ tbb;
  };

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Plot functionality requires additional packages.
    # These test also fail with 'RuntimeError: cannot cache function' error.
    "test_plot_runs_at_all"
    "test_umap_plot_testability"
    "test_umap_update_large"

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
    maintainers = [ ];
  };
}
