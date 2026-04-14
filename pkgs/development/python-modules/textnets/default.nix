{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  pdm-backend,
  setuptools,

  # dependencies
  igraph,
  leidenalg,
  matplotlib,
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
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jboynyc";
    repo = "textnets";
    tag = "v${version}";
    hash = "sha256-GbJH+6EqfP+miqpYitnBwNDO6uQQq3h9Fy58nVaF1vw=";
  };

  build-system = [
    cython
    pdm-backend
    setuptools
  ];

  pythonRelaxDeps = [
    "toolz"
  ];

  dependencies = [
    igraph
    leidenalg
    matplotlib
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

  disabledTests = [
    # https://github.com/jboynyc/textnets/issues/66
    "test_textnet_save_and_load"
  ];

  pythonImportsCheck = [ "textnets" ];

  # Enable the package to find the cythonized .so files during testing. See #255262
  # Set MPLBACKEND=agg for headless matplotlib on darwin. See #350784
  preCheck = ''
    rm -r textnets
    export MPLBACKEND=agg
  '';

  meta = {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
