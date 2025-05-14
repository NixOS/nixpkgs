{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  pythonOlder,
  requests,
  numpy,
  pandas,
  scipy,
  statsmodels,
  patsy,
  scikit-learn,
  tqdm,
  dask,
  distributed,
  stumpy,
  cloudpickle,
  pytestCheckHook,
  pytest-xdist,
  mock,
  matplotlib,
  seaborn,
  ipython,
  notebook,
  pandas-datareader,
}:

buildPythonPackage rec {
  pname = "tsfresh";
  version = "0.20.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blue-yonder";
    repo = "tsfresh";
    rev = "refs/tags/v${version}";
    hash = "sha256-Lw70PDiRVPiTzpnbfKSo7jjfBitCePSy15QL0z7+bMg=";
  };

  patches = [
    # The pyscaffold is not a build dependency but just a python project bootstrapping tool, so we do not need it
    ./remove-pyscaffold.patch
    ./remove-pytest-coverage-flags.patch
  ];

  dependencies = [
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

  disabledTests =
    [
      # touches network
      "test_relevant_extraction"
      "test_characteristics_downloaded_robot_execution_failures"
      "test_index"
      "test_binary_target_is_default"
      "test_characteristics_downloaded_robot_execution_failures"
      "test_extraction_runs_through"
      "test_multilabel_target_on_request"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # RuntimeError: Cluster failed to start: [Errno 1] Operation not permitted
      # may require extra privileges on darwin
      "test_local_dask_cluster_extraction_one_worker"
      "test_local_dask_cluster_extraction_two_worker"
      "test_dask_cluster_extraction_one_worker"
      "test_dask_cluster_extraction_two_workers"
    ];

  pythonImportsCheck = [ "tsfresh" ];

  meta = {
    description = "Automatic extraction of relevant features from time series";
    mainProgram = "run_tsfresh";
    homepage = "https://github.com/blue-yonder/tsfresh";
    changelog = "https://github.com/blue-yonder/tsfresh/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
