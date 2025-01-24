{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  incremental,
  packaging,
  systembridgemodels,
  pytest-aiohttp,
  pytest-socket,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "systembridgeconnector";
  version = "4.1.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    rev = "refs/tags/${version}";
    hash = "sha256-AzAN7reBAI4atEFutgFrdQHFy/Qc90PQxwSaHaftn5Q=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail ">=" " #"

    substituteInPlace systembridgeconnector/_version.py \
      --replace-fail ", dev=0" ""
  '';

  build-system = [
    incremental
    setuptools
  ];

  pythonRelaxDeps = [ "incremental" ];

  dependencies = [
    aiohttp
    incremental
    packaging
    systembridgemodels
  ];

  pythonImportsCheck = [ "systembridgeconnector" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-socket
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    "test_get_data"
    "test_wait_for_response_timeout"
  ];

  pytestFlagsArray = [ "--snapshot-warn-unused" ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
