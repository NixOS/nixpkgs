{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dill,
  numpy,
  pandas,
  psutil,
  scikit-learn,
  sortedcontainers,
  statsmodels,
  tqdm,
  typing-extensions,
  xgboost,

  # tests
  botorch,
  fastparquet,
  h5py,
  huggingface-hub,
  pymoo,
  pytest-timeout,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "syne-tune";
  version = "0.16.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "syne-tune";
    repo = "syne-tune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fejG/KWWT6HrGCGzGh4p/Q3kzIDgYbRgfwGQf5sgKic=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dill
    numpy
    pandas
    psutil
    scikit-learn
    sortedcontainers
    statsmodels
    tqdm
    typing-extensions
    xgboost
  ];

  pythonImportsCheck = [ "syne_tune" ];

  nativeCheckInputs = [
    botorch
    fastparquet
    h5py
    huggingface-hub
    pymoo
    pytest-timeout
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Large scale asynchronous hyperparameter and architecture optimization library";
    homepage = "https://github.com/syne-tune/syne-tune";
    changelog = "https://github.com/syne-tune/syne-tune/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
