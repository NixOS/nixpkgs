{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, htmlmin
, imagehash
, jinja2
, matplotlib
, multimethod
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
, numba
, dacite
, wordcloud
,
}:
buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.7.0";
  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7r9L1a2Cso7e0EeEX3n+QIrjuikHxJwYaTNjxm7AQac=";
  };

  propagatedBuildInputs = [
    htmlmin
    imagehash
    jinja2
    matplotlib
    multimethod
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
    numba
    dacite
    wordcloud
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyarrow
  ];

  postPatch = ''
    substituteInPlace src/ydata_profiling/utils/paths.py \
      --replace "    return get_project_root()" "    return Path.home() / '.cache/ydata-profiling'"
  '';

  disabledTestPaths = [
    # needs spark_session
    "tests/backends/spark_backend"
    # try to download data
    "tests/issues"
    "tests/unit/test_console.py"
    "tests/unit/test_dataset_schema.py"
    "tests/unit/test_modular.py"
  ];

  disabledTests = [
    "test_url"
    "test_example"
    "test_decorator"
    "test_serialize"
    "test_url"
  ];

  pythonImportsCheck = [
    "ydata_profiling"
  ];

  meta = with lib; {
    description = "1 Line of code data quality profiling & exploratory data analysis for Pandas and Spark DataFrames.";
    homepage = "https://github.com/ydataai/ydata-profiling";
    license = licenses.mit;
    mainProgram = "ydata_profiling";
    maintainers = with maintainers; [ katanallama ];
  };
}
