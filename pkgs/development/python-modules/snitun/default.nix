{ lib
, stdenv
, async-timeout
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.31.0";

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

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiplexer_data_channel_abort_full" # https://github.com/NabuCasa/snitun/issues/61
    # port binding conflicts
    "test_snitun_single_runner_timeout"
    "test_snitun_single_runner_throttling"
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "test_peer_listener_timeout"
  ];

  pythonImportsCheck = [ "snitun" ];

  meta = with lib; {
    homepage = "https://github.com/nabucasa/snitun";
    description = "SNI proxy with TCP multiplexer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = platforms.linux;
  };
}
