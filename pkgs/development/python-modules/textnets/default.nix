{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # dependencies
  cairocffi,
  igraph,
  leidenalg,
  pandas,
  pyarrow,
  scipy,
  spacy,
  spacy-lookups-data,
  toolz,
  tqdm,
  wasabi,

  # tests
  en_core_web_sm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textnets";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jboynyc";
    repo = "textnets";
    tag = "v${version}";
    hash = "sha256-MdKPxIshSx6U2EFGDTUS4EhoByyuVf0HKqvm9cS2KNY=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  pythonRelaxDeps = [
    "igraph"
    "leidenalg"
    "pyarrow"
    "toolz"
  ];

  dependencies = [
    cairocffi
    igraph
    leidenalg
    pandas
    pyarrow
    scipy
    spacy
    spacy-lookups-data
    toolz
    tqdm
    wasabi
  ];

  nativeCheckInputs = [
    en_core_web_sm
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textnets" ];

  # Enables the package to find the cythonized .so files during testing. See #255262
  preCheck = ''
    rm -r textnets
  '';

  disabledTests =
    [
      # Test fails: Throws a UserWarning asking the user to install `textnets[fca]`.
      "test_context"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # MemoryError: ("cairo returned CAIRO_STATUS_NO_MEMORY: b'out of memory'", 1)
      "test_plot_backbone"
      "test_plot_filtered"
      "test_plot_layout"
      "test_plot_projected"
      "test_plot_scaled"
    ];

  meta = {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
