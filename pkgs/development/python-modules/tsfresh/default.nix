{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, numpy
, pandas
, scipy
, statsmodels
, patsy
, scikit-learn
, tqdm
, dask
, distributed
, stumpy
, cloudpickle
, pytestCheckHook
, pytest-xdist
, mock
, matplotlib
, seaborn
, ipython
, notebook
, pandas-datareader
}:

buildPythonPackage rec {
  pname = "tsfresh";
  version = "0.20.1";
  pyproject = true;

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blue-yonder";
    repo = "tsfresh";
    rev = "v${version}";
    hash = "sha256-JmdP/6aTnuYsBRiRq9zZng3xNYhOdr9V8bp1trAv508=";
  };

  patches = [
    # The pyscaffold is not a build dependency but just a python project bootstrapping tool, so we do not need it
    ./remove-pyscaffold.patch
    ./remove-pytest-coverage-flags.patch
  ];

  propagatedBuildInputs = [
    requests
    numpy
    pandas
    scipy
    statsmodels
    patsy
    scikit-learn
    tqdm
    dask
    distributed
    stumpy
    cloudpickle
  ] ++ dask.optional-dependencies.dataframe;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    mock
    matplotlib
    seaborn
    ipython
    notebook
    pandas-datareader
  ];

  disabledTests = [
    # touches network
    "test_relevant_extraction"
    "test_characteristics_downloaded_robot_execution_failures"
    "test_index"
    "test_binary_target_is_default"
    "test_characteristics_downloaded_robot_execution_failures"
    "test_extraction_runs_through"
    "test_multilabel_target_on_request"
  ];

  pythonImportsCheck = [ "tsfresh" ];

  meta = with lib; {
    description = "Automatic extraction of relevant features from time series";
    homepage = "https://github.com/blue-yonder/tsfresh";
    changelog = "https://github.com/blue-yonder/tsfresh/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
