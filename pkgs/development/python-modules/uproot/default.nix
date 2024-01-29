{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, awkward
, hatch-vcs
, hatchling
, numpy
, fsspec
, packaging
, pandas
, pytestCheckHook
, lz4
, pytest-timeout
, rangehttpserver
, scikit-hep-testdata
, xxhash
, zstandard
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "5.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    rev = "refs/tags/v${version}";
    hash = "sha256-7X8oIMvOSC1JXQrZTPXLiqsUnfSc2Rx3KCvxKbhvPzM=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    awkward
    numpy
    fsspec
    packaging
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
    lz4
    pytest-timeout
    rangehttpserver
    scikit-hep-testdata
    xxhash
    zstandard
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # Tests that try to download files
    "test_fallback"
    "test_file"
    "test_fsspec_cache_http"
    "test_fsspec_cache_http_directory"
    "test_fsspec_chunks"
    "test_fsspec_globbing_http"
    "test_fsspec_writing_memory"
    "test_http"
    "test_http_fallback"
    "test_http_multipart"
    "test_http_port"
    "test_http_size"
    "test_http_size_port"
    "test_issue_1054_filename_colons"
    "test_no_multipart"
    "test_open_fsspec_http"
    "test_open_fsspec_github"
    "test_pickle_roundtrip_http"
  ];

  disabledTestPaths = [
    # Tests that try to download files
    "tests/test_0066_fix_http_fallback_freeze.py"
    "tests/test_0088_read_with_http.py"
    "tests/test_0220_contiguous_byte_ranges_in_http.py"

    # FileNotFoundError: uproot-issue-1043.root
    "tests/test_1043_const_std_string.py"
  ];

  pythonImportsCheck = [
    "uproot"
  ];

  meta = with lib; {
    description = "ROOT I/O in pure Python and Numpy";
    homepage = "https://github.com/scikit-hep/uproot5";
    changelog = "https://github.com/scikit-hep/uproot5/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
