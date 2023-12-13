{ lib
, buildPythonPackage
, cheroot
, colorama
, fetchFromGitHub
, fsspec
, hatch-vcs
, hatchling
, httpx
, pytest-xdist
, pytestCheckHook
, python-dateutil
, pythonOlder
, wsgidav
}:

buildPythonPackage rec {
  pname = "webdav4";
  version = "0.9.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "skshetry";
    repo = "webdav4";
    rev = "refs/tags/v${version}";
    hash = "sha256-Le/gABaUxMmSW2SjgucsBKqjxOq1h9UCAWl5YyUsCPk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
    python-dateutil
  ];

  nativeCheckInputs = [
    cheroot
    colorama
    pytest-xdist
    pytestCheckHook
    wsgidav
  ] ++ passthru.optional-dependencies.fsspec;

  passthru.optional-dependencies = {
    fsspec = [
      fsspec
    ];
    http2 = [
      httpx.optional-dependencies.http2
    ];
    all = [
      fsspec
      httpx.optional-dependencies.http2
    ];
  };

  pythonImportsCheck = [
    "webdav4"
  ];

  disabledTests = [
    # ValueError: Invalid dir_browser htdocs_path
    "test_retry_reconnect_on_failure"
    "test_open"
    "test_open_binary"
    "test_close_connection_if_nothing_is_read"
    # Assertion error due to comparing output
    "test_cp_cli"
    "test_mv_cli"
    "test_sync_remote_to_local"

  ];

  disabledTestPaths = [
    # Tests requires network access
    "tests/test_client.py"
    "tests/test_fsspec.py"
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Library for interacting with WebDAV";
    homepage = "https://skshetry.github.io/webdav4/";
    changelog = "https://github.com/skshetry/webdav4/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
