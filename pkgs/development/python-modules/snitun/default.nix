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
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snitun";
  version = "0.45.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "snitun";
    tag = version;
    hash = "sha256-luXv5J0PUvW+AGTecwkEq+qkG1N5Ja5NbBKJ3M6HC0I=";
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

  meta = with lib; {
    description = "SNI proxy with TCP multiplexer";
    changelog = "https://github.com/NabuCasa/snitun/releases/tag/${src.tag}";
    homepage = "https://github.com/nabucasa/snitun";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = platforms.linux;
  };
}
