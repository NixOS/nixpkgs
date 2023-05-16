{ lib
<<<<<<< HEAD
, stdenv
, buildPythonPackage
, fetchFromGitHub
, exceptiongroup
=======
, buildPythonPackage
, fetchFromGitHub
, async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-trio
, pytestCheckHook
, trio
, trustme
, wsproto
}:

buildPythonPackage rec {
  pname = "trio-websocket";
<<<<<<< HEAD
  version = "0.10.2";
  format = "setuptools";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "HyperionGray";
    repo = "trio-websocket";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-djoTxkIKY52l+WnxL1FwlqrU/zvsLVkPUAHn9BxJ45k=";
  };

  propagatedBuildInputs = [
    exceptiongroup
=======
    hash = "sha256-8VrpI/pk5IhEvqzo036cnIbJ1Hu3UfQ6GHTNkNJUYvo=";
  };

  propagatedBuildInputs = [
    async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    trio
    wsproto
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
    trustme
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ ];
=======
  pythonImportsCheck = [ "trio_websocket" ];

  meta = with lib; {
    description = "WebSocket client and server implementation for Python Trio";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
