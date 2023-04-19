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
  version = "0.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7UGsziNUI4dxdMGuJWrvsQiwl+IvcO/rQqEOjl9wS1Y=";
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

  disabledTests = lib.optionals stdenv.isDarwin [
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
