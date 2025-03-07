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
  seaborn,
  statsmodels,
  tqdm,
  typeguard,
  visions,
  wordcloud,
}:

buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = "ydata-profiling";
    tag = "v${version}";
    hash = "sha256-K2axhkshKnJO8sKqSWW4AbdQXsVlR6xwuhRP3Q5J08E=";
  };

  preBuild = ''
    echo ${version} > VERSION
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "imagehash"
    "scipy"
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

  meta = with lib; {
    description = "Create HTML profiling reports from Pandas DataFrames";
    homepage = "https://ydata-profiling.ydata.ai";
    changelog = "https://github.com/ydataai/ydata-profiling/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "ydata_profiling";
  };
}
