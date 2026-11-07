{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  dask,
  distributed,
  numpy,
  pandas,
  patsy,
  pywavelets,
  requests,
  scikit-learn,
  scipy,
  statsmodels,
  stumpy,
  tqdm,

  # testing
  ipython,
  matplotlib,
  mock,
  notebook,
  pandas-datareader,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  seaborn,
}:

buildPythonPackage (finalAttrs: {
  pname = "tsfresh";
  version = "0.21.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blue-yonder";
    repo = "tsfresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rOEzcAQ2kiskHsFezPee+GNI0IuuZomqtMB6ev0uop8=";
  };

  patches = [
    # The pyscaffold is not a build dependency but just a python project bootstrapping tool, so we do not need it
    ./remove-pyscaffold.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "requires = [\"setuptools<70\", \"wheel\", \"pyscaffold>=3.3a0,<4\"]" \
      "requires = [\"setuptools\", \"wheel\"]" \
  '';

  build-system = [
    setuptools
  ];

  # Upstream doesn't supply a version field anywhere, so patching it is out of the question.
  dontCheckPythonMetadata = true;

  dependencies = [
    cloudpickle
    dask
    distributed
    numpy
    pandas
    patsy
    pywavelets
    requests
    scikit-learn
    scipy
    statsmodels
    stumpy
    tqdm
  ]
  ++ dask.optional-dependencies.dataframe;

  # python-datareader is disabled on Python 3.12+ and is require only for checks.
  doCheck = !pandas-datareader.disabled;

  nativeCheckInputs = [
    ipython
    matplotlib
    mock
    notebook
    pandas-datareader
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    seaborn
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
    changelog = "https://github.com/blue-yonder/tsfresh/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
