{
  lib,
  stdenv,
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
  version = "5.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    rev = "refs/tags/v${version}";
    hash = "sha256-a5gCsv8iBUUASHCJIpxFbgBXTSm/KJOTt6fvSvP/Lio=";
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

  disabledTests =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Tries to connect to localhost:22
      # PermissionError: [Errno 1] Operation not permitted
      "test_open_fsspec_ssh"
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
