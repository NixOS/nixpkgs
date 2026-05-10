{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  dacite,
  filetype,
  imagehash,
  jinja2,
  matplotlib,
  minify-html,
  multimethod,
  numba,
  numpy,
  pandas,
  phik,
  pydantic,
  pyyaml,
  requests,
  scipy,
  seaborn,
  statsmodels,
  tqdm,
  typeguard,
  visions,
  wordcloud,

  # tests
  pyarrow,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ydata-profiling";
  version = "4.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = "ydata-profiling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CNeHsOpFkKvcCWGEholabcsqXJzINUUxFZ7I5bPBoYM=";
  };

  # pydantic.v1.errors.ConfigError: unable to infer type for attribute "sortby"
  disabled = pythonAtLeast "3.14";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=72.0.0,<80.0.0" "setuptools" \
      --replace-fail "setuptools-scm>=8.0.0,<9.0.0" "setuptools-scm"
  '';

  preBuild = ''
    echo ${finalAttrs.version} > VERSION
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "imagehash"
    "matplotlib"
    "multimethod"
    "numba"
    "numpy"
    "scipy"
  ];

  dependencies = [
    dacite
    filetype
    imagehash
    jinja2
    matplotlib
    minify-html
    multimethod
    numba
    numpy
    pandas
    phik
    pydantic
    pyyaml
    requests
    scipy
    seaborn
    setuptools
    statsmodels
    tqdm
    typeguard
    visions
    wordcloud
  ];

  nativeCheckInputs = [
    pyarrow
    pytestCheckHook
  ];

  disabledTestPaths = [
    # needs Spark:
    "tests/backends/spark_backend"

    # try to download data:
    "tests/issues"
    "tests/unit/test_console.py"
    "tests/unit/test_dataset_schema.py"
    "tests/unit/test_modular.py"
  ];

  disabledTests = [
    # try to download data:
    "test_decorator"
    "test_example"
    "test_load"
    "test_urls"
  ];

  pythonImportsCheck = [ "ydata_profiling" ];

  meta = {
    description = "Create HTML profiling reports from Pandas DataFrames";
    homepage = "https://ydata-profiling.ydata.ai";
    changelog = "https://github.com/ydataai/ydata-profiling/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "ydata_profiling";
  };
})
