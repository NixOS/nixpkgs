{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  guidata,
  makefun,
  numpy,
  packaging,
  pandas,
  pywavelets,
  scikit-image,
  scipy,
  typing-extensions,

  # optional-dependencies
  babel,
  build,
  coverage,
  pre-commit,
  pylint,
  ruff,
  wheel,
  matplotlib,
  myst-nb,
  myst-parser,
  opencv-python-headless,
  plotpy,
  pydata-sphinx-theme,
  pyqt5,
  qtpy,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  sphinx-gallery,
  sphinx-intl,
  pytest,
  pytest-xvfb,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sigima";
  version = "1.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "Sigima";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQrUn/WgWZ5W9Lrg4TJjerEZvGDH1wKL2WbeP3sGjrE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    guidata
    makefun
    numpy
    packaging
    pandas
    pywavelets
    scikit-image
    scipy
    typing-extensions
  ];

  optional-dependencies = {
    dev = [
      babel
      build
      coverage
      pre-commit
      pylint
      ruff
      setuptools
      wheel
    ];
    doc = [
      matplotlib
      myst-nb
      myst-parser
      opencv-python-headless
      plotpy
      pydata-sphinx-theme
      pyqt5
      qtpy
      sphinx
      sphinx-copybutton
      sphinx-design
      sphinx-gallery
      sphinx-intl
    ];
    opencv = [
      opencv-python-headless
    ];
    qt = [
      plotpy
      pyqt5
      qtpy
    ];
    test = [
      pytest
      pytest-xvfb
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  pythonImportsCheck = [
    "sigima"
  ];

  meta = {
    description = "Scientific computing engine for 1D signals and 2D images";
    homepage = "https://github.com/DataLab-Platform/Sigima";
    changelog = "https://github.com/DataLab-Platform/Sigima/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
