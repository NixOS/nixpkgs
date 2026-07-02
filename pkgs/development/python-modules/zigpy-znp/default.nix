{
  lib,
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
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-znp";
    tag = "v${version}";
    hash = "sha256-beIFbmJ6h1wj+e+g+JvXedvBFjnjaTZ60PCYTbiUqic=";
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

  meta = {
    description = "Library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    changelog = "https://github.com/zigpy/zigpy-znp/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
}
