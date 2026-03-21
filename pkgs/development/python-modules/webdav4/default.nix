{
  lib,
  buildPythonPackage,
  cheroot,
  colorama,
  fetchFromGitHub,
  fsspec,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-xdist,
  pytestCheckHook,
  pytest-cov-stub,
  python-dateutil,
  wsgidav,
}:

buildPythonPackage (finalAttrs: {
  pname = "webdav4";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skshetry";
    repo = "webdav4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vWOxFoPxXFf5hmzbu9Ik3Mqg/70eFehqMF46gC6aDzQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    httpx
    python-dateutil
  ];

  optional-dependencies = {
    fsspec = [ fsspec ];
    http2 = [ httpx.optional-dependencies.http2 ];
    all = [
      fsspec
      httpx.optional-dependencies.http2
    ];
  };

  nativeCheckInputs = [
    cheroot
    colorama
    pytest-xdist
    pytestCheckHook
    pytest-cov-stub
    wsgidav
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "webdav4" ];

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

  meta = {
    description = "Library for interacting with WebDAV";
    mainProgram = "dav";
    homepage = "https://skshetry.github.io/webdav4/";
    changelog = "https://github.com/skshetry/webdav4/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
