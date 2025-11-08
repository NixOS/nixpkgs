{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  awkward,
  cramjam,
  fsspec,
  numpy,
  packaging,

  # tests
  awkward-pandas,
  pandas,
  pytest-timeout,
  pytestCheckHook,
  rangehttpserver,
  scikit-hep-testdata,
  writableTmpDirAsHomeHook,
  xxhash,
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "5.6.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    tag = "v${version}";
    hash = "sha256-Kk8Paa6vx364BBfzfxh8f3muevwNg0I7n5CszjiWUo0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    awkward
    cramjam
    fsspec
    numpy
    packaging
    xxhash
  ];

  nativeCheckInputs = [
    awkward-pandas
    pandas
    pytest-timeout
    pytestCheckHook
    rangehttpserver
    scikit-hep-testdata
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Tests that try to download files
    "test_descend_into_path_classname_of"
    "test_fallback"
    "test_fsspec_cache_http"
    "test_fsspec_cache_http_directory"
    "test_fsspec_chunks"
    "test_fsspec_globbing_http"
    "test_http"
    "test_http_fallback_workers"
    "test_http_multipart"
    "test_http_port"
    "test_http_size"
    "test_http_size_port"
    "test_http_workers"
    "test_issue176"
    "test_issue176_again"
    "test_issue_1054_filename_colons"
    "test_no_multipart"
    "test_open_fsspec_github"
    "test_open_fsspec_http"
    "test_pickle_roundtrip_http"

    # Cyclic dependency with dask-awkward
    "test_dask_duplicated_keys"
    "test_decompression_executor_for_dask"
    "test_decompression_threadpool_executor_for_dask"
  ];

  disabledTestPaths = [
    # Tests that try to download files
    "tests/test_0066_fix_http_fallback_freeze.py"
    "tests/test_0220_contiguous_byte_ranges_in_http.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "uproot" ];

  meta = {
    description = "ROOT I/O in pure Python and Numpy";
    homepage = "https://github.com/scikit-hep/uproot5";
    changelog = "https://github.com/scikit-hep/uproot5/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
