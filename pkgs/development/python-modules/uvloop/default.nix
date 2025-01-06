{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # build-system
  cython,
  setuptools,

  # native dependencies
  libuv,
  CoreServices,
  ApplicationServices,

  # tests
  psutil,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.21.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O/ErD9poRHgGp62Ee/pZFhMXcnXTW2ckse5XP6o3BOM=";
  };

  postPatch = ''
    rm -rf vendor

    substituteInPlace setup.py \
      --replace-fail "use_system_libuv = False" "use_system_libuv = True"
  '';

  build-system = [
    cython
    setuptools
  ];

  env.LIBUV_CONFIGURE_HOST = stdenv.hostPlatform.config;

  buildInputs =
    [ libuv ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreServices
      ApplicationServices
    ];

  nativeCheckInputs = [
    pyopenssl
    pytestCheckHook
    psutil
  ];

  pytestFlagsArray =
    [
      # Tries to run "env", but fails to find it, even with coreutils provided
      "--deselect=tests/test_process.py::Test_UV_Process::test_process_env_2"
      "--deselect=tests/test_process.py::Test_AIO_Process::test_process_env_2"
      # AssertionError: b'' != b'out\n'
      "--deselect=tests/test_process.py::Test_UV_Process::test_process_streams_redirect"
      "--deselect=tests/test_process.py::Test_AIO_Process::test_process_streams_redirect"
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      "--deselect=tests/test_tcp.py::Test_UV_TCPSSL::test_create_connection_ssl_failed_certificat"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # Segmentation fault
      "--deselect=tests/test_fs_event.py::Test_UV_FS_EVENT_RENAME::test_fs_event_rename"
      # Broken: https://github.com/NixOS/nixpkgs/issues/160904
      "--deselect=tests/test_context.py::Test_UV_Context::test_create_ssl_server_manual_connection_lost"
    ];

  disabledTestPaths = [
    # ignore code linting tests
    "tests/test_sourcecode.py"
  ];

  preCheck =
    ''
      # force using installed/compiled uvloop
      rm -rf uvloop
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Work around "OSError: AF_UNIX path too long"
      # https://github.com/MagicStack/uvloop/issues/463
      export TMPDIR="/tmp"
    '';

  pythonImportsCheck = [
    "uvloop"
    "uvloop.loop"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/MagicStack/uvloop/releases/tag/v${version}";
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = "https://github.com/MagicStack/uvloop";
    license = licenses.mit;
    maintainers = [ ];
  };
}
