{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  exceptiongroup,
  pytest-trio,
  pytestCheckHook,
  trio,
  trustme,
  wsproto,
}:

buildPythonPackage rec {
  pname = "trio-websocket";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HyperionGray";
    repo = "trio-websocket";
    rev = version;
    hash = "sha256-ddLbYkb1m9zRjv3Lb7YwUzj26gYbK4nYN6jN+FAuiOs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    trio
    wsproto
  ] ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
    trustme
  ];

  disabledTests =
    [
      # https://github.com/python-trio/trio-websocket/issues/187
      "test_handshake_exception_before_accept"
      "test_reject_handshake"
      "test_reject_handshake_invalid_info_status"
      "test_client_open_timeout"
      "test_client_close_timeout"
      "test_client_connect_networking_error"
      "test_finalization_dropped_exception"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Failed: DID NOT RAISE <class 'ValueError'>
      "test_finalization_dropped_exception"
      # Timing related
      "test_client_close_timeout"
      "test_cm_exit_with_pending_messages"
      "test_server_close_timeout"
      "test_server_handler_exit"
      "test_server_open_timeout"
    ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "trio_websocket" ];

  meta = with lib; {
    changelog = "https://github.com/HyperionGray/trio-websocket/blob/${version}/CHANGELOG.md";
    description = "WebSocket client and server implementation for Python Trio";
    homepage = "https://github.com/HyperionGray/trio-websocket";
    license = licenses.mit;
    maintainers = [ ];
  };
}
