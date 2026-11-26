{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  grpcio-tools,
  pybind11,
  setuptools,

  # dependencies
  absl-py,
  array-record,
  cloudpickle,
  etils,
  numpy,
  portpicker,
  protobuf,

  # optional-dependencies
  pyarrow,

  # tests
  attrs,
  jax,
  parameterized,
  prometheus-client,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "grain";
  version = "0.2.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "grain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZP08rQM9zUvShb2Gvz3V/lcOj2Yi3qx/JRYXF7Tvt8U=";
  };

  build-system = [
    grpcio-tools
    pybind11
    setuptools
  ];

  dependencies = [
    absl-py
    array-record
    cloudpickle
    etils
    numpy
    portpicker
    protobuf
  ]
  ++ etils.optional-dependencies.epath
  ++ etils.optional-dependencies.epy;

  optional-dependencies = {
    parquet = [ pyarrow ];
  };

  pythonImportsCheck = [
    "grain"
    "grain.experimental"
    "grain.python"
  ];

  nativeCheckInputs = [
    attrs
    jax
    parameterized
    prometheus-client
    pytest-xdist
    pytestCheckHook
    typing-extensions
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Tests live inside the package: run them against the installed copy, which has the
  # compiled extension.
  preCheck = ''
    rm -rf grain
  '';
  enabledTestPaths = [
    "${placeholder "out"}/${python.sitePackages}/grain"
  ];
  disabledTestPaths = [
    # Requires tensorflow
    "${placeholder "out"}/${python.sitePackages}/grain/_src/core/tf_import_smoke_test.py"
  ];
  disabledTests = [
    # AssertionError: no logs of level INFO or higher triggered on root
    "test_execution_summary_with_no_logging"
  ];

  # Upstream sets these per bazel test target
  env = {
    EXPECTED_FRAMEWORK = "jax";
    PYTHON_VERSION = python.pythonVersion;
  };

  pytestFlags = [
    "-pno:cacheprovider"
    "-opython_files=*_test.py"
    # Prevent test dirs from being prepended to sys.path: grain/_src/python/ipc/queue.py would
    # shadow the stdlib `queue` module in multiprocessing workers.
    "--import-mode=importlib"
    "-oconsider_namespace_packages=true"
  ];

  meta = {
    description = "Library for reading and processing ML training data";
    homepage = "https://github.com/google/grain";
    changelog = "https://github.com/google/grain/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
