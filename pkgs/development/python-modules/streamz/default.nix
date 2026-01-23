{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  toolz,
  tornado,
  zict,

  # tests
  dask,
  distributed,
  flaky,
  pandas,
  pyarrow,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamz";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-streamz";
    repo = "streamz";
    tag = finalAttrs.version;
    hash = "sha256-OoWFOACrJ8zXJJ1bmRukj04zx+s1Zgg9KqlJooLDRW0=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    pytest-asyncio
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
})
