{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pillow,
  sphinx,

  # optional-dependencies
  absl-py,
  graphviz,
  intersphinx-registry,
  ipython,
  joblib,
  jupyterlite-sphinx,
  lxml,
  matplotlib,
  mypy,
  numpy,
  packaging,
  plotly,
  pydata-sphinx-theme,
  pytest,
  pytest-cov,
  seaborn,
  sphinx-design,
  statsmodels,
  types-docutils,
  types-pillow,
  memory-profiler,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-gallery";
  version = "0.21.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sphinx-gallery";
    repo = "sphinx-gallery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eWU2xNnguyXi2AZ/PpBp0Pv3IsgL9wQMyPuQpNbn9cY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pillow
    sphinx
  ];

  optional-dependencies = {
    animations = [
      #sphinxcontrib-video
    ];
    dev = [
      absl-py
      graphviz
      intersphinx-registry
      ipython
      joblib
      jupyterlite-sphinx
      lxml
      matplotlib
      mypy
      numpy
      packaging
      plotly
      pydata-sphinx-theme
      pytest
      pytest-cov
      seaborn
      sphinx-design
      #sphinxcontrib-video
      statsmodels
      types-docutils
      types-pillow
      #types-pygments
    ];
    jupyterlite = [
      jupyterlite-sphinx
    ];
    parallel = [
      joblib
    ];
    recommender = [
      numpy
    ];
    show-api-usage = [
      graphviz
    ];
    show-memory = [
      memory-profiler
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.dev;

  # TODO:
  disabledTests = [
    # requires the sphinxcontrib.video package
    "test_dummy_image"
    # urllib.error.URLError: <urlopen error [Errno -3] Temporary failure in name resolution>
    "test_embed_code_links_get_data"
  ];

  pythonImportsCheck = [
    "sphinx_gallery"
  ];

  meta = {
    description = "Sphinx extension for automatic generation of an example gallery";
    homepage = "https://github.com/sphinx-gallery/sphinx-gallery";
    changelog = "https://github.com/sphinx-gallery/sphinx-gallery/blob/${finalAttrs.src.rev}/CHANGES.rst";
    mainProgram = "sphinx_gallery_py2jupyter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
