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
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-znp";
    tag = "v${version}";
    hash = "sha256-B4AyCLuhKUdQ0nzwFy5xWXpzR31R50lcC5EJMIJfDKE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 20" "timeout = 300" \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [ "--reruns=3" ];

  disabledTests = [
    # broken by https://github.com/zigpy/zigpy/pull/1635
    "test_concurrency_auto_config"
    "test_request_concurrency"
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
