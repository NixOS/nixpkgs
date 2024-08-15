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
  version = "4.1.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    rev = "refs/tags/${version}";
    hash = "sha256-uqE/KJnuNii2b3geB9jp8IxaeceuZVXdol7s3hP6z/Q=";
  };

  postPatch = ''
    substituteInPlace systembridgeconnector/_version.py \
      --replace-fail ", dev=0" ""
  '';

  build-system = [ setuptools ];

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

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
