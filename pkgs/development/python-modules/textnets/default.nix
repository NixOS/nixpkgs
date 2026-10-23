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

buildPythonPackage (finalAttrs: {
  pname = "textnets";
  version = "0.10.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jboynyc";
    repo = "textnets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KBKpA4nnHxem65tZTtZcXl/EVS1ifWOXGT7a/750Gk=";
  };

  # tqdm 4.70.0 regression: thread_map fails on iterables without a length hint
  # https://github.com/tqdm/tqdm/issues/1828 (fixed in tqdm 4.70.1)
  postPatch = ''
    substituteInPlace textnets/corpus.py \
      --replace-fail \
        "thread_map(nlp_ufunc, doc_chunks," \
        "thread_map(nlp_ufunc, list(doc_chunks),"

    substituteInPlace textnets/network.py \
      --replace-fail \
        "thread_map(sig_ufunc, edge_chunks," \
        "thread_map(sig_ufunc, list(edge_chunks),"
  '';

  build-system = [
    cython
    pdm-backend
    setuptools
  ];

  pythonRelaxDeps = [
    "pandas"
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

  pythonImportsCheck = [ "textnets" ];

  nativeCheckInputs = [
    en_core_web_sm
    pytestCheckHook
  ];

  preCheck =
    # Enable the package to find the cythonized .so files during testing. See #255262
    ''
      rm -r textnets
    ''
    # Set MPLBACKEND=agg for headless matplotlib on darwin. See #350784
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export MPLBACKEND=agg
    '';

  meta = {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jboy ];
  };
})
