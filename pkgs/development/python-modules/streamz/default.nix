{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  six,
  toolz,
  tornado,
  zict,

  # tests
  dask,
  distributed,
  flaky,
  pandas,
  pyarrow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-streamz";
    repo = "streamz";
    tag = version;
    hash = "sha256-lSb3gl+TSIzz4BZzxH8zXu74HvzSntOAoVQUUJKIEvA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    toolz
    tornado
    zict
  ];

  nativeCheckInputs = [
    dask
    distributed
    flaky
    pandas
    pyarrow
    pytestCheckHook
  ];

  pythonImportsCheck = [ "streamz" ];

  disabledTests = [
    # Error with distutils version: fixture 'cleanup' not found
    "test_separate_thread_without_time"
    "test_await_syntax"
    "test_partition_then_scatter_sync"
    "test_sync"
    "test_sync_2"

    # Tests are flaky
    "test_buffer"
    "test_partition_timeout_cancel"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
