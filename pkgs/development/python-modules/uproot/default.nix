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
  numpy,
  fsspec,
  packaging,

  # checks
  awkward-pandas,
  pandas,
  pytestCheckHook,
  pytest-timeout,
  rangehttpserver,
  scikit-hep-testdata,
  xxhash,
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "5.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    rev = "refs/tags/v${version}";
    hash = "sha256-letdC246I9LDqEnLCOTz51cBnQGbkrsR/i7UN6EMcDA=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    awkward
    cramjam
    numpy
    fsspec
    packaging
    xxhash
  ];

  nativeCheckInputs = [
    awkward-pandas
    pandas
    pytestCheckHook
    pytest-timeout
    rangehttpserver
    scikit-hep-testdata
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # Tests that try to download files
    "test_descend_into_path_classname_of"
    "test_fallback"
    "test_file"
    "test_fsspec_cache_http"
    "test_fsspec_cache_http_directory"
    "test_fsspec_chunks"
    "test_fsspec_globbing_http"
    "test_fsspec_writing_http"
    "test_fsspec_writing_memory"
    "test_fsspec_writing_ssh"
    "test_http"
    "test_http_fallback"
    "test_http_multipart"
    "test_http_port"
    "test_http_size"
    "test_http_size_port"
    "test_issue_1054_filename_colons"
    "test_multiple_page_lists"
    "test_no_multipart"
    "test_open_fsspec_github"
    "test_open_fsspec_http"
    "test_open_fsspec_ss"
    "test_pickle_roundtrip_http"
    "test_split_ranges_if_large_file_in_http"
    # Cyclic dependency with dask-awkward
    "test_dask_duplicated_keys"
    "test_decompression_executor_for_dask"
    "test_decompression_threadpool_executor_for_dask"
  ];

  disabledTestPaths = [
    # Tests that try to download files
    "tests/test_0066_fix_http_fallback_freeze.py"
    "tests/test_0088_read_with_http.py"
    "tests/test_0220_contiguous_byte_ranges_in_http.py"
  ];

  pythonImportsCheck = [ "uproot" ];

  meta = {
    description = "ROOT I/O in pure Python and Numpy";
    homepage = "https://github.com/scikit-hep/uproot5";
    changelog = "https://github.com/scikit-hep/uproot5/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
