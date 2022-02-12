{ lib
, stdenv
, async-timeout
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ehafb35H462Ffn6omGh/MDJKQX5qJJZeiIBO3n0IGlA=";
  };

  propagatedBuildInputs = [
    async-timeout
    attrs
    cryptography
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "snitun"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiplexer_data_channel_abort_full" # https://github.com/NabuCasa/snitun/issues/61
    # port binding conflicts
    "test_snitun_single_runner_timeout"
    "test_snitun_single_runner_throttling"
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "test_peer_listener_timeout"
  ];

  meta = with lib; {
    description = "SNI proxy with TCP multiplexer";
    homepage = "https://github.com/nabucasa/snitun";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab Scriptkiddi ];
    platforms = platforms.linux;
  };
}
