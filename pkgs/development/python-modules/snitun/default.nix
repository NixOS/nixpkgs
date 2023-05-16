{ lib
, stdenv
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
<<<<<<< HEAD
  version = "0.36.1";
=======
  version = "0.35.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ViFAPAA6uU5MQNHCTIw0OTR8eZPgF34GqRP+py6L6RU=";
=======
    hash = "sha256-sZMmou9uHThl7AIMnuBxABnWTF1CCFsDj1I7FYxgJ3Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    async-timeout
    attrs
    cryptography
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = [
    # broke after aiohttp 3.8.5 upgrade
    "test_client_stop_no_wait"
  ] ++ lib.optionals stdenv.isDarwin [
=======
  disabledTests = lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_multiplexer_data_channel_abort_full" # https://github.com/NabuCasa/snitun/issues/61
    # port binding conflicts
    "test_snitun_single_runner_timeout"
    "test_snitun_single_runner_throttling"
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "test_peer_listener_timeout"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # TypeError: Passing coroutines is forbidden, use tasks explicitly.
    "test_snitun_runner_updown"
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
