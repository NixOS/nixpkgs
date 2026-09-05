{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-codspeed,
  pytestCheckHook,
  setuptools,
  trustme,
}:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "snitun";
    tag = version;
    hash = "sha256-l7iXTXY6Dq1LV4ju6/WlipTSeybne33tiFYiwgy+DuM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-codspeed
    pytestCheckHook
    trustme
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_multiplexer_data_channel_abort_full" # https://github.com/NabuCasa/snitun/issues/61
    # port binding conflicts
    "test_snitun_single_runner_timeout"
    "test_snitun_single_runner_throttling"
    # ConnectionResetError: [Errno 54] Connection reset by peer
    "test_peer_listener_timeout"
  ];

  pythonImportsCheck = [ "snitun" ];

  meta = {
    description = "SNI proxy with TCP multiplexer";
    changelog = "https://github.com/NabuCasa/snitun/releases/tag/${src.tag}";
    homepage = "https://github.com/nabucasa/snitun";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    platforms = lib.platforms.linux;
  };
}
