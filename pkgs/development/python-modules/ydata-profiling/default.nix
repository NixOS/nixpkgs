{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  dacite,
  htmlmin,
  imagehash,
  jinja2,
  matplotlib,
  multimethod,
  numba,
  numpy,
  pandas,
  phik,
  pyarrow,
  pydantic,
  pyyaml,
  requests,
  scipy,
  setuptools,
  setuptools-scm,
  seaborn,
  statsmodels,
  tqdm,
  typeguard,
  visions,
  wordcloud,
}:

buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.16.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = "ydata-profiling";
    tag = "v${version}";
    hash = "sha256-gmMEW1aAwBar/xR22Wm98hbjP20ty3idvxfqCJ1uRGM=";
  };

  preBuild = ''
    echo ${version} > VERSION
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "imagehash"
    "matplotlib"
    "multimethod"
    "numpy"
  ];

  dependencies = [
    dacite
    htmlmin
    imagehash
    jinja2
    matplotlib
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
    changelog = "https://github.com/ydataai/ydata-profiling/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "ydata_profiling";
  };
}
