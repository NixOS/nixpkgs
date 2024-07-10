{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, dacite
, htmlmin
, imagehash
, jinja2
, matplotlib
, multimethod
, numba
, numpy
, pandas
, phik
, pyarrow
, pydantic
, pyyaml
, requests
, scipy
, seaborn
, statsmodels
, tqdm
, typeguard
, visions
, wordcloud
}:

buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.8.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tMwhoVnn65EvZK5NBvh/G36W8tH7I9qaL+NTK3IZVdI=";
  };

  preBuild = ''
    echo ${version} > VERSION
  '';

  propagatedBuildInputs = [
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
    pytestCheckHook
    pyarrow
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

  pythonImportsCheck = [
    "ydata_profiling"
  ];

  meta = with lib; {
    description = "Create HTML profiling reports from Pandas DataFrames";
    homepage = "https://ydata-profiling.ydata.ai";
    changelog = "https://github.com/ydataai/ydata-profiling/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "ydata_profiling";
  };
}
