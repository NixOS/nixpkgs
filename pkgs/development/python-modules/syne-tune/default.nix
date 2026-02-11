{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dill,
  numpy,
  pandas,
  sortedcontainers,
  typing-extensions,

  # optional-dependencies
  autograd,
  botorch,
  # configspace,
  fastparquet,
  h5py,
  huggingface-hub,
  matplotlib,
  pymoo,
  scikit-learn,
  scipy,
  # smac,
  statsmodels,
  xgboost,
  # yahpo-gym,

  # tests
  pytestCheckHook,
  pytest-timeout,
  ray,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "syne-tune";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "syne-tune";
    repo = "syne-tune";
    tag = "v${version}";
    hash = "sha256-51QyfJ0XOcXTeE95YOhtUmhat23joaEYvUnk7hYfksY=";
  };

  postPatch = ''
    substituteInPlace syne_tune/optimizer/schedulers/synchronous/hyperband.py \
     --replace-fail 'metric_val=np.NAN' 'metric_val=np.nan'
    substituteInPlace syne_tune/optimizer/schedulers/synchronous/dehb.py \
     --replace-fail 'result_failed.metric_val = np.NAN' 'result_failed.metric_val = np.nan'
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    dill
    numpy
    pandas
    sortedcontainers
    typing-extensions
  ];

  optional-dependencies = lib.fix (self: {
    blackbox-repository = [
      fastparquet
      h5py
      huggingface-hub
      numpy
      pandas
      scikit-learn
      xgboost
    ];
    bore = [
      scikit-learn
      xgboost
    ];
    botorch = [ botorch ];
    gpsearchers = [
      autograd
      scipy
    ];
    kde = [ statsmodels ];
    moo = [
      pymoo
      scipy
    ];
    sklearn = [ scikit-learn ];
    # smac = [ smac swig ]; # smac unavailable on nixpkgs
    visual = [ matplotlib ];
    # yahpo = [ configspace onnxruntime pandas pyyaml yahpo-gym ]; # yahpo-gym unavailable on nixpkgs
  });

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    ray
    writableTmpDirAsHomeHook
  ]
  ++ ray.optional-dependencies.tune
  ++ optional-dependencies.blackbox-repository
  ++ optional-dependencies.bore
  ++ optional-dependencies.botorch
  ++ optional-dependencies.gpsearchers
  ++ optional-dependencies.kde
  ++ optional-dependencies.sklearn;

  disabledTests = [
    # NameError: name 'HV' is not defined
    # these require pkg `pymoo` and adding `pymoo` raises:
    # setuptools.errors.PackageDiscoveryError: Multiple top-level packages discovered in a flat-layout: ['cma', 'notebooks'].
    "test_append_hypervolume_indicator"
    "test_hypervolume"
    "test_hypervolume_progress"
    "test_hypervolume_simple"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # assert np.float64(1.0114686865847489e-12) < 1e-12
    "test_cholesky_factorization"
  ];

  disabledTestPaths = [
    # legacy test
    "tst/schedulers/test_legacy_schedulers_api.py"
  ];

  pythonImportsCheck = [
    "syne_tune"
  ];

  meta = {
    description = "Large scale asynchronous hyperparameter and architecture optimization library";
    homepage = "https://github.com/syne-tune/syne-tune";
    changelog = "https://github.com/syne-tune/syne-tune/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
