{
  lib,
  async-timeout,
  buildPythonPackage,
  coloredlogs,
  fetchFromGitHub,
  jsonschema,
  pytest-asyncio,
  pytest-mock,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6ApwGB6VvG+XiE8U85gg/EWnYniMb+1fqmNwtHGcf/I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 20" "timeout = 300" \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ];

  doCheck = false; # tests are not compatible with zigpy 0.65.3

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--reruns=3" ];

  disabledTests = [
    # failing since zigpy 0.60.0
    "test_join_device"
    "test_nonstandard_profile"
    "test_permit_join"
    "test_request_recovery_route_rediscovery_zdo"
    "test_watchdog"
    "test_zigpy_request"
    "test_zigpy_request_failure"
  ];

  pythonImportsCheck = [ "zigpy_znp" ];

  meta = with lib; {
    description = "Library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    changelog = "https://github.com/zigpy/zigpy-znp/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
