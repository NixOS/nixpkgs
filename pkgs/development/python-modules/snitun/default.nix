{ lib
, stdenv
, setuptools
, async-timeout
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.36.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "snitun";
    rev = "refs/tags/${version}";
    hash = "sha256-ViNsmTq1iLxNujA71b9JZB5AZ79ZbiqdTyDeBGd4gUA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    attrs
    cryptography
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Expected 'fileno' to not have been called. Called 1 times.
    "test_client_stop_no_wait"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_multiplexer_data_channel_abort_full" # https://github.com/NabuCasa/snitun/issues/61
    # port binding conflicts
    "test_snitun_single_runner_timeout"
    "test_snitun_single_runner_throttling"
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "test_peer_listener_timeout"
  ] ++ lib.optionals (pythonAtLeast "3.12") [
    # blocking
    "test_flow_client_peer"
    "test_close_client_peer"
    "test_init_connector"
    "test_flow_connector"
    "test_close_connector_remote"
    "test_init_connector_whitelist"
    "test_init_multiplexer_server"
    "test_init_multiplexer_client"
    "test_init_multiplexer_server_throttling"
    "test_init_multiplexer_client_throttling"
    "test_multiplexer_ping"
    "test_multiplexer_ping_error"
    "test_multiplexer_init_channel_full"
    "test_multiplexer_close_channel_full"
    "test_init_dual_peer_with_multiplexer"
  ];

  pythonImportsCheck = [ "snitun" ];

  meta = with lib; {
    changelog = "https://github.com/NabuCasa/snitun/releases/tag/${version}";
    homepage = "https://github.com/nabucasa/snitun";
    description = "SNI proxy with TCP multiplexer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = platforms.linux;
  };
}
