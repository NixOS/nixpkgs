{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pythonRelaxDepsHook
, fastparquet
, htmlmin
, imagehash
, jinja2
, matplotlib
, multimethod
, numpy
, pandas
, phik
, pydantic
, pyyaml
, requests
, scipy
, seaborn
, statsmodels
, tqdm
, typeguard
, visions
}:

buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.1.2";
  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ydataai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-q0qbNVFKHJ/mrwtr3yRpFlU2hSY3CNiTXI3FIqfMSII=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "numpy" "scipy" "matplotlib" ];

  preBuild = ''
    echo ${version} > VERSION
  '';

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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fastparquet
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
    "test_example"
    "test_decorator"
    "test_serialize"
    "test_url"
  ];

  pythonImportsCheck = [
    "ydata_profiling"
  ];

  meta = with lib; {
    description = "Create HTML profiling reports from Pandas DataFrames";
    homepage = "https://ydata-profiling.ydata.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "ydata_profiling";
  };
}
