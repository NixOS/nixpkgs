{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numba,
  numpy,
  pynndescent,
  scikit-learn,
  scipy,
  tqdm,

  # optional-dependencies
  bokeh,
  colorcet,
  dask,
  datashader,
  holoviews,
  matplotlib,
  pandas,
  scikit-image,
  seaborn,
  tensorflow,
  tensorflow-probability,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.9.post2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    tag = "release-${version}";
    hash = "sha256-ollUXPVB07v6DkQ/d1eke0/j1f4Ekfygo1r6CtIRTuk=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
      dask
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

    tbb = [
      # Not packaged.
      #tbb
    ];

    all = plot ++ parametric_umap ++ tbb;
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

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

  meta = {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    changelog = "https://github.com/lmcinnes/umap/releases/tag/release-${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
